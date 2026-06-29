#' @title Statistical Analysis of LST vs NDVI
#' @file scripts/04_statistical_analysis.R
#' @description Extracts pixel values from LST and NDVI rasters, calculates
#' Pearson correlation, and generates scatter plots with linear regression trends.

# 1. Load required libraries
if (!requireNamespace("ggplot2", quietly = TRUE)) install.packages("ggplot2")
library(terra)
library(ggplot2)

# 2. Define analysis function
analyze_relationship <- function(city_name) {
  cat(sprintf("Analyzing LST vs NDVI relationship for %s...\n", city_name))
  
  # Define file paths
  lst_path <- sprintf("data/processed/%s_lst_celsius.tif", tolower(city_name))
  ndvi_path <- sprintf("data/processed/%s_ndvi.tif", tolower(city_name))
  
  # Load rasters
  lst <- rast(lst_path)
  ndvi <- rast(ndvi_path)
  
  # Rename bands for clarity
  names(lst) <- "LST"
  names(ndvi) <- "NDVI"
  
  # Combine into a single multi-band raster
  city_raster <- c(ndvi, lst)
  
  # 3. Statistical Sampling
  # Sample 5,000 random pixels to avoid overplotting and optimize performance
  cat("Sampling pixels for statistical analysis...\n")
  sample_df <- as.data.frame(spatSample(city_raster, size = 5000, na.rm = TRUE))
  
  # 4. Calculate Pearson Correlation Coefficient
  cor_val <- cor(sample_df$NDVI, sample_df$LST, use = "complete.obs")
  cat(sprintf("📈 Pearson Correlation (R) for %s: %.2f\n", city_name, cor_val))
  
  # 5. Generate Scatter Plot using ggplot2
  cat("Generating scatter plot...\n")
  p <- ggplot(sample_df, aes(x = NDVI, y = LST)) +
    geom_point(alpha = 0.4, color = "#2c3e50") +
    geom_smooth(method = "lm", color = "#e74c3c", linewidth = 1.2, se = TRUE) +
    labs(
      title = sprintf("Urban Heat Island Mitigation Analysis: %s", city_name),
      subtitle = sprintf("Pearson Correlation Coefficient: %.2f", cor_val),
      x = "Vegetation Index (NDVI)",
      y = "Land Surface Temperature (°C)"
    ) +
    theme_minimal(base_size = 12) +
    theme(
      plot.title = element_text(face = "bold", size = 14),
      plot.subtitle = element_text(color = "#555555", face = "italic"),
      panel.grid.minor = element_blank()
    )
  
  # 6. Save the final plot as a high-resolution PNG
  output_plot_path <- sprintf("data/processed/%s_lst_vs_ndvi.png", tolower(city_name))
  ggsave(output_plot_path, plot = p, width = 8, height = 6, dpi = 300)
  cat(sprintf("Success! Plot saved to: %s\n\n", output_plot_path))
}

# 3. Run the analysis for both cities
analyze_relationship("Milan")
analyze_relationship("Termoli")