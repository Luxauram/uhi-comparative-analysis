#' @title Calculate NDVI (Normalized Difference Vegetation Index)
#' @file scripts/03_process_ndvi.R
#' @description Calculates NDVI using Band 4 (Red) and Band 5 (NIR) for both Milan and Termoli.

library(terra)
library(sf)
library(dplyr)

# 1. Load the municipal boundaries
cat("Loading municipal boundaries...\n")
aoi <- st_read("data/processed/aoi_milano_termoli.gpkg", quiet = TRUE)
milan_vect <- vect(aoi %>% filter(COMUNE == "Milano"))
termoli_vect <- vect(aoi %>% filter(COMUNE == "Termoli"))

# 2. Function to compute NDVI
process_ndvi <- function(city_name, city_vect, pattern) {
  cat(sprintf("Calculating NDVI for %s...\n", city_name))
  
  # Locate the correct satellite folder (LC08 for Milan, LC09 for Termoli)
  raw_dirs <- list.dirs("data/raw", recursive = FALSE)
  city_dir <- raw_dirs[grepl(pattern, raw_dirs)]
  
  if(length(city_dir) == 0) stop(sprintf("Error: %s folder not found!", city_name))
  
  # Find Band 4 and Band 5
  b4_path <- list.files(city_dir, pattern = "B4\\.TIF$", full.names = TRUE)
  b5_path <- list.files(city_dir, pattern = "B5\\.TIF$", full.names = TRUE)
  
  b4 <- rast(b4_path)
  b5 <- rast(b5_path)
  
  # Align vector CRS to raster CRS
  city_vect_proj <- project(city_vect, crs(b4))
  
  # OPTIMIZATION TRICK: Crop and mask before the math calculation
  cat("Cropping to city boundaries...\n")
  b4_crop <- mask(crop(b4, city_vect_proj), city_vect_proj)
  b5_crop <- mask(crop(b5, city_vect_proj), city_vect_proj)
  
  # MATH: NDVI = (NIR - Red) / (NIR + Red)
  cat("Applying NDVI formula...\n")
  ndvi <- (b5_crop - b4_crop) / (b5_crop + b4_crop)
  
  # Save the result
  output_path <- sprintf("data/processed/%s_ndvi.tif", tolower(city_name))
  writeRaster(ndvi, output_path, overwrite = TRUE)
  
  cat("Success! NDVI saved to:", output_path, "\n\n")
}

# 3. Run the processing for both cities
process_ndvi("Milan", milan_vect, "LC08")
process_ndvi("Termoli", termoli_vect, "LC09")