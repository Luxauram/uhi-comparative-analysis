#' @title Fetch and Prepare Administrative Boundaries (AOI)
#' @file scripts/00_setup_data.R
#' @description Automates the downloading of the latest ISTAT generalized
#' boundaries.
#' Extracts and filters spatial data for the specified Areas of Interest (Milan
#' and Termoli), saving the output as a lightweight, QGIS-ready GeoPackage.
#'
#' @author Luca D'Aurizio (Luxauram)

# Install packages
if (!requireNamespace("sf", quietly = TRUE)) install.packages("sf")
if (!requireNamespace("dplyr", quietly = TRUE)) install.packages("dplyr")

library(sf)
library(dplyr)

# Directory and URL setup
# It's used ISTAT "generalized" boundaries because is lighter and perfect for satellite cropping
url_istat <- "https://www.istat.it/storage/cartografia/confini_amministrativi/generalizzati/2024/Limiti01012024_g.zip"
dest_zip <- "data/raw/istat_comuni_2024.zip"
unzip_dir <- "data/raw/istat_unzipped"

# Create Directories
dir.create("data/raw", recursive = TRUE, showWarnings = FALSE)
dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)

# Download and Extraction
cat("Starting download of ISTAT boundaries (this might take a few seconds)...\n")
download.file(url_istat, destfile = dest_zip, mode = "wb")

cat("Extracting ZIP file...\n")
unzip(dest_zip, exdir = unzip_dir)

# Dynamic identification of Municipalities shapefile
shp_file <- list.files(unzip_dir, pattern = "^Com.*\\.shp$", full.names = TRUE, recursive = TRUE)

if(length(shp_file) == 0) {
  stop("Error: Could not find the Municipalities shapefile.")
}

# Spatial reading and filtering
cat("Loading map and filtering for Milan and Termoli...\n")
comuni_ita <- st_read(shp_file[1], quiet = TRUE)

aoi_studio <- comuni_ita %>%
  filter(COMUNE %in% c("Milano", "Termoli"))

# Output Saving in GeoPackage format
output_file <- "data/processed/aoi_milano_termoli.gpkg"

# Save file
st_write(aoi_studio, output_file, append = FALSE, quiet = TRUE)

cat("Success! The file", output_file, "has been successfully created.\n")
cat("You can now drag and drop it directly into QGIS!\n")
