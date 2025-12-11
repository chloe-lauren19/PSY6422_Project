# Functions and Themes -------------------------------------------------
#############################################################
## Description :: Makes new functions for this project
#############################################################

## Functions -------------------------------------------------
# Check if packages are installed, if not then install them
check_packages <- function(package){
  if(!package %in% installed.packages()[ ,"Package"]){
    install.packages(package)
  }
}

# Create data frame for the missing data
missing_data <- function(modality, date, count){
  data.frame(
    modalities = modality,
    date_published = date,
    n = count
  )
}

## Themes -------------------------------------------------
# Make a custom theme
theme_neuroimaging = theme(
  plot.title = element_text(size = 12, hjust = 0.5),
  axis.title = element_text(size = 10),
  legend.position = "right",
  legend.title = element_text(size = 10),
  panel.background = element_rect("gray100"),
  panel.grid.major = element_line(colour = "gray87"),
  axis.line = element_line(colour = "gray10")
)
