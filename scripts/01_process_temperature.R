#' @title Calculate Land Surface Temperature (LST)
#' @file scripts/01_process_temperature.R
#' @description Extracts the thermal band (Band 10) from Landsat 8, applies 
#' radiometric calibration to Top of Atmosphere (TOA) radiance, converts it 
#' to Brightness Temperature in Kelvin, and finally to Celsius. Crops the 
#' output to the Milan AOI.

# 1. Load required libraries
if (!requireNamespace("terra", quietly = TRUE)) install.packages("terra")
library(terra)
library(sf)
library(dplyr)

# 2. Locate the Landsat 8 folder and Band 10 dynamically
cat("Searching for Landsat 8 thermal band in data/raw...\n")
raw_dirs <- list.dirs("data/raw", recursive = FALSE)
milan_dir <- raw_dirs[grepl("LC08", raw_dirs)]

if(length(milan_dir) == 0) stop("Error: Milan Landsat 8 folder not found!")

# Get the full path to Band 10 (Thermal Infrared)
b10_path <- list.files(milan_dir, pattern = "B10\\.TIF$", full.names = TRUE)

# 3. Load the raster and the Milan boundary
cat("Loading raster and Milan boundary...\n")
b10 <- rast(b10_path)
aoi <- st_read("data/processed/aoi_milano_termoli.gpkg", quiet = TRUE)

# Filter for Milan and convert to 'SpatVector' (the format required by terra)
milan_sf <- aoi %>% filter(COMUNE == "Milano")
milan_vect <- vect(milan_sf)

# 4. Landsat 8 Collection 2 Band 10 Calibration Constants
# These are standard NASA constants found in the MTL.txt file
M_L <- 3.3420e-04  # Radiance Multiplier
A_L <- 0.10000     # Radiance Add
K1 <- 774.8853     # Thermal Conversion Constant 1
K2 <- 1321.0789    # Thermal Conversion Constant 2

# 5. Spatial Mathematics: Pixel-by-pixel calculation
cat("Calculating TOA Radiance...\n")
radiance <- (b10 * M_L) + A_L

cat("Converting to Kelvin...\n")
temp_k <- K2 / log((K1 / radiance) + 1)

cat("Converting to Celsius...\n")
temp_c <- temp_k - 273.15

# 6. Crop and Mask to Milan AOI
cat("Cropping the satellite image to Milan municipal borders...\n")
# Reproject the vector to match the satellite's Coordinate Reference System (UTM)
milan_vect_proj <- project(milan_vect, crs(temp_c))

# Crop (bounding box) and Mask (exact polygon borders)
milan_temp <- crop(temp_c, milan_vect_proj)
milan_temp <- mask(milan_temp, milan_vect_proj)

# 7. Save the final processed raster
output_path <- "data/processed/milan_lst_celsius.tif"
writeRaster(milan_temp, output_path, overwrite = TRUE)

cat("Success! The thermal map has been saved to:", output_path, "\n")