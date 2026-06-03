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

### Step 2: Fetching Base Data (AOI)

To generate the Area of Interest (AOI) boundaries for Milan and Termoli:

1. Run the setup script located in the `scripts` folder:
   ```R
   source("scripts/00_setup_data.R")
   ```

_This script automatically downloads the latest generalized municipal boundaries from ISTAT, extracts them, filters for Milan and Termoli, and saves a clean `aoi_milano_termoli.gpkg` file in the `data/processed/` folder._

### Step 3: Satellite Imagery (Landsat)

Due to file size constraints and GitHub best practices, the raw satellite images (approx. 1GB each) are not included in this repository. To reproduce the analysis, you must download the exact same Landsat scenes used for this study.

**Data Source:** [USGS EarthExplorer](https://earthexplorer.usgs.gov/) _(Note: A free EROS account is required for downloading)._

**Search Criteria & Sensor:**

- **Dataset:** Landsat 8-9 OLI/TIRS C2 L1 (Collection 2, Level-1)
- **Cloud Cover:** Less than 10%

**Specific Scenes Used:**
To maximize the visibility of the UHI effect, scenes were selected during the peak of the August 2023 heatwave (Anticyclone "Nero"), ensuring maximum thermal stress and zero precipitation in the preceding days.

1. **Milan (Lombardy):**
   - Acquisition Date: `2023-08-22`
   - Satellite: Landsat 8
   - Scene ID: `LC08_L1TP_193028_20230822_20230826_02_T1`

2. **Termoli (Molise):**
   - Acquisition Date: `2023-08-18`
   - Satellite: Landsat 9
   - Scene ID: `LC09_L1TP_189031_20230818_20230818_02_T1`

**Installation:**
Download the `Product Bundle` (.tar archives) for both scenes. Extract them and place the resulting folders directly into the `data/raw/` directory.

### Step 4: QGIS Project

Once the base data and satellite imagery are downloaded into the `data/` folder, you can open the QGIS project file (`qgis_project/progetto_calore.qgz`). All layers are configured with relative paths, so they will load automatically.

## License

This project is licensed under the [MIT License](LICENSE).
