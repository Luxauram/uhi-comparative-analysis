#' @title Calculate Land Surface Temperature (LST) - Termoli
#' @file scripts/02_process_temperature_termoli.R
#' @description Extracts the thermal band (Band 10) from Landsat 9, converts to Celsius,
#' and crops to the Termoli AOI.

library(terra)
library(sf)
library(dplyr)

# 1. Locate the Landsat 9 folder dynamically
cat("Searching for Landsat 9 thermal band in data/raw...\n")
raw_dirs <- list.dirs("data/raw", recursive = FALSE)
termoli_dir <- raw_dirs[grepl("LC09", raw_dirs)]

if(length(termoli_dir) == 0) stop("Error: Termoli Landsat 9 folder not found! Did you extract it?")

b10_path <- list.files(termoli_dir, pattern = "B10\\.TIF$", full.names = TRUE)

# 2. Load the raster and the Termoli boundary
cat("Loading raster and Termoli boundary...\n")
b10 <- rast(b10_path)
aoi <- st_read("data/processed/aoi_milano_termoli.gpkg", quiet = TRUE)

termoli_sf <- aoi %>% filter(COMUNE == "Termoli")
termoli_vect <- vect(termoli_sf)

# 3. Landsat Calibration Constants (L9 uses the same structure as L8)
M_L <- 3.3420e-04
A_L <- 0.10000
K1 <- 774.8853
K2 <- 1321.0789

# 4. Spatial Mathematics
cat("Calculating TOA Radiance...\n")
radiance <- (b10 * M_L) + A_L

cat("Converting to Kelvin...\n")
temp_k <- K2 / log((K1 / radiance) + 1)

cat("Converting to Celsius...\n")
temp_c <- temp_k - 273.15

# 5. Crop and Mask to Termoli AOI
cat("Cropping the satellite image to Termoli municipal borders...\n")
termoli_vect_proj <- project(termoli_vect, crs(temp_c))
termoli_temp <- crop(temp_c, termoli_vect_proj)
termoli_temp <- mask(termoli_temp, termoli_vect_proj)

# 6. Save the final processed raster
output_path <- "data/processed/termoli_lst_celsius.tif"
writeRaster(termoli_temp, output_path, overwrite = TRUE)

cat("Success! The thermal map has been saved to:", output_path, "\n")