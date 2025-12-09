# Functions -------------------------------------------------
#############################################################
## Description :: Makes new functions for this project
#############################################################

# check if packages are installed, if not then install them
check_packages <- function(package){
  if(!package %in% installed.packages()[ ,"Package"]){
    install.packages(package)
  }
}
