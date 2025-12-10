# Master Script ---------------------------------------------
## Description :: loads all packages and scripts needed for -
## this project

# Packages --------------------------------------------------

## Check if packages are installed, if not, install them
check_packages("tidyverse")
check_packages("here")

## Load packages
library(tidyverse)
library(here)

# Settings --------------------------------------------------

## Set seed to ensure results are reproducible if random -
## generators are used
set.seed(1234567)

## Load functions into this project
source("R_scripts/001_functions.R")

# Processing ------------------------------------------------

## Load in all scripts for this project
source("R_scripts/002_dataprep.R")
