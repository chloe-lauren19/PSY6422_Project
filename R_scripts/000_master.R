# Master Script ---------------------------------------------
## Description :: loads all packages and scripts needed for -
## this project

# Packages --------------------------------------------------

## Check if packages are installed, if not, install them
check_packages("tidyverse")
check_packages("here")
check_packages("plotly")
check_packages("gganimate")

## Load packages
library(tidyverse)
library(here)
library(plotly)

# Settings --------------------------------------------------

## Set seed to ensure results are reproducible if random -
## generators are used
set.seed(1234567)

## Load functions into this project
source("R_scripts/001_functions.R")

# Processing ------------------------------------------------

## Load in all scripts for this project
source("R_scripts/002_dataprep.R")
source("R_scripts/003_visualisations.R")