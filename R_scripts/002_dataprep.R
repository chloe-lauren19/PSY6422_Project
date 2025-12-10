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
         date_published = as.Date(made_public, "%m/%d/%Y")) %>% # Create a date_published column with a date data type
  select(ID, date_published, modalities, species) # Remove the made_public column

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

### Sanity check: Ensure the total number of observations is 846 in the human_data 
### and that the only categories are "multimodal", "eeg", "meg", "dMRI", "fMRI", and "sMRI"
modality_count <- modality_data %>% 
  group_by(modalities) %>% 
  count() 

sum(modality_count$n)

## Save final data set --------------------------------------
### If the above sanity check is passed then save the data as below
neuroimaging_overtime <- modality_data

### Preview the final dataset
head(neuroimaging_overtime, 10)
