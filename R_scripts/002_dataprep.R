# Data Preparation ------------------------------------------
## Description :: Clean the data ready to produce a -
## visualisation

## Load data ------------------------------------------------
### Load the neuroscience data and save as a tibble
neuroscience_raw <- read_csv(here("datasets", "neuroscience_metadata.csv"))
as.tibble(neuroscience_raw)

## View data ------------------------------------------------
### View the first 10 rows of the data
head(neuroscience_raw, n = 10)

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
modality_data <- human_data %>% 
  group_by(modalities) %>% 
  count()








