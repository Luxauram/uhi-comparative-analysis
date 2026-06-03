# Urban Heat Island (UHI) Analysis: Milan vs Termoli

> **Spatial and statistical analysis of the Urban Heat Island (UHI) effect: a comparative case study between Milan and Termoli using remote sensing (QGIS + R).**

## Project Overview

This project investigates the relationship between urbanization, vegetation cover (NDVI), and the formation of Urban Heat Islands (UHI). By analyzing satellite imagery from Landsat 8/9, this study compares two distinct Italian urban environments:

- **Milan (Lombardy):** A highly urbanized, densely populated metropolitan area.
- **Termoli (Molise):** A smaller, coastal town with different vegetation dynamics and maritime climate influence.

The goal is to quantitatively assess how the density of the built environment and the presence of Green Infrastructure (GI) mitigate or exacerbate summer land surface temperatures (LST).

## Technologies Used

- **QGIS:** For spatial data ingestion, raster calculation (NDVI, LST extraction via Semi-Automatic Classification Plugin), and geoprocessing.
- **R & RStudio:** For statistical analysis, spatial data preparation, and data visualization (`sf`, `dplyr`, `ggplot2`).
- **Git/GitHub:** For version control and reproducible research.

## How to Run the Project

To keep this repository lightweight, raw spatial data (like satellite imagery and national shapefiles) are **not** tracked by Git. Follow these steps to reproduce the environment locally:

### Step 1: R Environment Setup

This project uses `renv` to manage R package dependencies.

1. Open the project in RStudio (or your preferred R IDE).
2. Run the following command in the R console to install the exact package versions used in this project:
   ```R
   renv::restore()
   ```
