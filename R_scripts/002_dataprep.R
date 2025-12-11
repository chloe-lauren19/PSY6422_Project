# Data Preparation ------------------------------------------
## Description :: Clean the data ready to produce a -
## visualisation

## Load data ------------------------------------------------
### Load the neuroscience data and save as a tibble
neuroscience_raw <- read_csv(here("datasets", "neuroscience_metadata.csv"))
as.tibble(neuroscience_raw)

## View data ------------------------------------------------
### View the first 10 rows of the data
head(neuroscience_raw, 10)

### View a summary of the data to understand the variables
summary(neuroscience_raw)

## Clean data -----------------------------------------------
### Make dataset with just the variables needed for the -
### project
neuroscience_data <- neuroscience_raw %>% 
  select(made_public, modalities, species) %>% # Only retain these columns
  drop_na() %>% # Remove all rows containing NAs
  mutate(ID = row_number(), .before = 1, # Create an ID column to the left of the dataset
         date = as.Date(made_public, "%m/%d/%Y"), # Create a date column
         date_published = format(date, "%Y")) %>% # Remove the day and month
  select(ID, date_published, modalities, species)  # Remove the made_public and date column


### Remove subjects that aren't human
human_data <- neuroscience_data %>% 
  filter(species == "Human")

### Sanity Check: check that there aren't any non-human species remaining
for(i in human_data$species){
  if(i != "Human"){
    print("Test Failed")
  }
}


## Transform data -------------------------------------------
### View the number of modalities in the dataset and save as a dataset
modality_count <- human_data %>% 
  group_by(modalities) %>% 
  count()

### Remove unspecified groups in modalities variable and rename with imaging categories
modality_data <- human_data %>% 
  filter(modalities != "beh") %>% 
  mutate(modalities = case_match(modalities, 
                                 c("bold, events, t1w",
                                   "eeg, nirs",
                                   "mri_diffusion, mri_functional, mri",
                                   "mri_diffusion, mri_functional, mri_structural, eeg, mri",
                                   "mri_diffusion, mri_functional, mri_structural, mri",
                                   "mri_diffusion, mri_structural, eeg, mri",
                                   "mri_diffusion, mri_structural, mri",
                                   "mri_diffusion, mri_structural, mri_functional, mri",
                                   "mri_diffusion, mri_structural, mri_functional, mri, pet",
                                   "mri_diffusion, mri_structural, mri_functional, mri_perfusion, mri",
                                   "mri_functional, mri, eeg",
                                   "mri_functional, mri_diffusion, mri_structural, eeg, mri, beh",
                                   "mri_functional, mri_diffusion, mri_structural, meg, mri",
                                   "mri_functional, mri_diffusion, mri_structural, mri",
                                   "mri_functional, mri_perfusion, mri_structural, mri",
                                   "mri_functional, mri_structural, eeg, mri",
                                   "mri_functional, mri_structural, mri",
                                   "mri_functional, mri_structural, mri, beh",
                                   "mri_functional, mri_structural, mri, eeg",
                                   "mri_functional, mri_structural, mri, eeg, beh",
                                   "mri_functional, mri_structural, mri, ieeg",
                                   "mri_functional, mri_structural, mri_diffusion, mri",
                                   "mri_functional, mri_structural, pet_dynamic, mri, pet",
                                   "mri_functional, pet_static, mri_structural, pet_dynamic, mri, pet",
                                   "mri_structural, eeg, mri",
                                   "mri_structural, ieeg, mri",
                                   "mri_structural, meg, mri",
                                   "mri_structural, meg, mri, beh",
                                   "mri_structural, mri, pet",
                                   "mri_structural, mri_diffusion, mri",
                                   "mri_structural, mri_diffusion, mri_functional, mri",
                                   "mri_structural, mri_diffusion, mri_functional, mri, eeg",
                                   "mri_structural, mri_functional, ieeg, mri",
                                   "mri_structural, mri_functional, mri",
                                   "mri_structural, mri_functional, mri, eeg",
                                   "mri_structural, pet, mri",
                                   "pet_dynamic, mri_functional, mri_structural, mri, pet",
                                   "t1w, bold, events",
                                   "t1w, bold, events, fieldmap",
                                   "t1w, channels, eeg, events, bold") ~ "multimodal",
                                 c("channels, eeg, electrodes, events", 
                                   "channels, eeg, events",
                                   "eeg, beh",
                                   "ieeg",
                                   "ieeg, eeg") ~ "eeg",
                                 "meg, beh" ~ "meg",
                                 "mri_diffusion, mri" ~ "dMRI",
                                 "mri_functional, mri" ~ "fMRI",
                                 c("mri_structural, mri",
                                   "t1w") ~ "sMRI",
                                 .default = modalities))

### Sanity check: Ensure the total number of observations is 846 
### and that the only categories are "multimodal", "eeg", "meg", "dMRI", "fMRI", and "sMRI"
modality_count <- modality_data %>% 
  group_by(modalities) %>% 
  count() 

sum(modality_count$n)


## Reshaping the data -------------------------------------
### If the above sanity check is passed then calculate the count for each modality per year
neuroimaging_overtime <- modality_data %>% 
  group_by(modalities) %>% 
  count(date_published)

### Sanity check: Ensure the total of column 'n' is 846
sum(neuroimaging_overtime$n)

### View the first 10 rows of the data
head(neuroimaging_overtime, 10)

### Some modalities don't have data for every year
### To ensure this is reflected in the plot, add rows for these cases where n = 0
### First make a new dataframe with the missing data:

### dMRI is missing 2018, 2019, 2020, 2021, 2022, and 2023
dMRI_rows <- missing_data("dMRI", c("2018", "2019", "2020", "2021", "2022", "2023"), 0)

### eeg is missing 2018
eeg_rows <- missing_data("eeg", "2018", 0)

### fMRI is missing 2018, 2019, and 2022
fMRI_rows <- missing_data("fMRI", c("2018", "2019", "2022"), 0)

### meg is missing 2018 and 2019
meg_rows <- missing_data("meg", c("2018", "2019"), 0)

### nirs is missing 2018, 2019, 2020, 2021, and 2022
nirs_rows <- missing_data("nirs", c("2018", "2019", "2020", "2021", "2022"), 0)

### sMRI is missing 2018
sMRI_rows <- missing_data("sMRI", "2018", 0)

### Join the missing data dataframes
missing_modality_years <- rbind(dMRI_rows, eeg_rows, fMRI_rows, meg_rows, nirs_rows, sMRI_rows)

### Join missing_modality_years and neuroimaging_overtime
neuroimaging_final <- rbind(neuroimaging_overtime, missing_modality_years)

### Order the dataframe by modality and date_published
neuroimaging_final <- neuroimaging_final[with(neuroimaging_final, order(modalities, date_published)), ]

### Preview the final dataset
head(neuroimaging_final, 10)
