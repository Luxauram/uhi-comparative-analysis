# Urban Heat Island (UHI) Analysis: Milan vs Termoli

> **Spatial and statistical analysis of the Urban Heat Island (UHI) effect: a comparative case study between Milan and Termoli using remote sensing (QGIS + R).**

## Project Overview

This project investigates the relationship between urbanization, vegetation cover (NDVI), and the formation of Urban Heat Islands (UHI). By analyzing satellite imagery from Landsat 8/9, this study compares two distinct Italian urban environments:

- **Milan (Lombardy):** A highly urbanized, densely populated metropolitan area with a continental climate.
- **Termoli (Molise):** A smaller, coastal town with different vegetation dynamics and a maritime climate influence.

The goal is to quantitatively assess how the density of the built environment and the presence of Green Infrastructure (GI) mitigate or exacerbate summer land surface temperatures (LST) - and to mathematically demonstrate the mitigation effect of urban vegetation through statistical correlation analysis.

## Methodology

The project relies on a programmatic and fully reproducible workflow:

1. **R (`terra`, `sf`, `dplyr`):** Heavy spatial computation. Extracts Band 10 (Thermal) to calculate TOA Radiance, Brightness Temperature, and Celsius LST. Also processes Band 4 (Red) and Band 5 (NIR) to compute NDVI.
2. **QGIS:** Spatial visualization - pseudocolor ramps, transparency layers, and OpenStreetMap basemaps to contextually analyze the UHI effect across neighborhoods.
3. **R (`ggplot2`):** Statistical sampling (5,000 random pixels per city) and scatter plots with linear regression to compute the Pearson Correlation Coefficient.

## Results

The statistical analysis confirms a **negative correlation between vegetation presence and surface temperature**, but highlights how geographical context significantly shapes the UHI dynamic.

### Milan (Continental)

- **Pearson Correlation (R):** `-0.70`
- **Insight:** Strong negative correlation. In a landlocked, densely built environment, vegetation is the primary mitigating factor against extreme heat.

![LST vs NDVI Milan](data/processed/milan_lst_vs_ndvi.png)

### Termoli (Coastal)

- **Pearson Correlation (R):** `-0.52`
- **Insight:** Moderate negative correlation. While vegetation still lowers temperatures, the cooling effect of the Adriatic Sea breeze strongly influences the local microclimate, making the UHI effect less strictly dependent on NDVI alone.

![LST vs NDVI Termoli](data/processed/termoli_lst_vs_ndvi.png)

## Technologies Used

- **QGIS:** Spatial data ingestion, raster calculation (NDVI, LST extraction via Semi-Automatic Classification Plugin), and geoprocessing.
- **R & RStudio:** Statistical analysis, spatial data preparation, and visualization (`terra`, `sf`, `dplyr`, `ggplot2`).
- **Git/GitHub:** Version control and reproducible research.

## Repository Structure

```
.
├── data/
│   ├── raw/              # Raw Landsat .tar archives + ISTAT boundaries (git-ignored)
│   └── processed/        # Clipped rasters (.tif), vectors (.gpkg), output plots (.png)
├── scripts/              # R scripts for spatial processing and statistical analysis
└── qgis_project/         # QGIS project file (.qgz) with styled map layouts
```

## How to Run the Project

To keep this repository lightweight, raw spatial data (satellite imagery, national shapefiles) are **not** tracked by Git. Follow these steps to reproduce the environment locally.

### Step 1: R Environment Setup

Make sure R is installed, then install the required packages:

```R
install.packages(c("terra", "sf", "dplyr", "ggplot2"))
```

### Step 2: Fetching Base Data (AOI)

Run the setup script to generate the Area of Interest boundaries for Milan and Termoli:

```R
source("scripts/00_setup_data.R")
```

This script automatically downloads the latest generalized municipal boundaries from ISTAT, extracts them, filters for Milan and Termoli, and saves a clean `aoi_milano_termoli.gpkg` in `data/processed/`.

### Step 3: Satellite Imagery (Landsat)

Raw satellite images (~1 GB each) are not included due to file size. Download the exact scenes used for this study from [USGS EarthExplorer](https://earthexplorer.usgs.gov/) _(free EROS account required)_.

**Search Criteria:**

- **Dataset:** Landsat 8-9 OLI/TIRS C2 L1 (Collection 2, Level-1)
- **Cloud Cover:** Less than 10%

**Scenes Used:**
Selected during the peak of the August 2023 heatwave (Anticyclone "Nero"), ensuring maximum thermal stress and zero prior precipitation.

| City    | Date       | Satellite | Scene ID                                   |
| ------- | ---------- | --------- | ------------------------------------------ |
| Milan   | 2023-08-22 | Landsat 8 | `LC08_L1TP_193028_20230822_20230826_02_T1` |
| Termoli | 2023-08-18 | Landsat 9 | `LC09_L1TP_189031_20230818_20230818_02_T1` |

Download the `Product Bundle` (.tar archives) for both scenes, extract them, and place the resulting folders directly into `data/raw/`.

### Step 4: Run the Analysis Scripts

Execute the R scripts in order:

```R
source("scripts/01_process_temperature.R")       # LST for Milan
source("scripts/02_process_temperature_termoli.R") # LST for Termoli
source("scripts/03_process_ndvi.R")              # NDVI for both cities
source("scripts/04_statistical_analysis.R")      # Correlation + plots
```

### Step 5: QGIS Visualization

Open `qgis_project/progetto_calore.qgz` to explore the spatial data. All layers use relative paths and will load automatically once the data is in place.

## License

This project is licensed under the [MIT License](LICENSE).
