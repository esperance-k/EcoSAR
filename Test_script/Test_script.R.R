# =========================================================
# EcoSAR Test Script – Sentinel-1 SAR Data Processing
# =========================================================

# ---------------------------------------------------------
# 1️⃣ Set Python Environment (MUST be first)
# ---------------------------------------------------------
library(reticulate)

# Force R to use the correct Miniconda rgee environment
use_python("C:/Users/PC/miniconda3/envs/rgee/python.exe", required = TRUE)

# Check Python configuration
py_config()


# ---------------------------------------------------------
# 2️⃣ Load rgee and Initialize Earth Engine
# ---------------------------------------------------------
library(rgee)

# Initialize Google Earth Engine
ee_Initialize(force = TRUE)


# ---------------------------------------------------------
# 3️⃣ Load EcoSAR Package (Local Development Version)
# ---------------------------------------------------------
library(devtools)

# Load EcoSAR from your local package folder
load_all("C:/R_Package/EcoSAR")

# DO NOT use library(EcoSAR) when using load_all()


# ---------------------------------------------------------
# 4️⃣ Define Area of Interest (AOI) and Dates
# ---------------------------------------------------------
# Bounding box format: xmin, ymin, xmax, ymax
bbox_test <- c(15, -4, 15.5, -3.5)

start_date <- "2023-01-01"
end_date   <- "2023-01-31"


# ---------------------------------------------------------
# 5️⃣ Load Sentinel-1 SAR Data
# ---------------------------------------------------------
cat("Loading Sentinel-1 SAR data...\n")

radar_col <- radar_load(
  start_date  = start_date,
  end_date    = end_date,
  bbox        = bbox_test,
  polarization = "VV"   # Choose "VV" or "VH"
)

print(radar_col)


# ---------------------------------------------------------
# 6️⃣ Compute Mean Radar Backscatter
# ---------------------------------------------------------
cat("Computing mean radar backscatter...\n")

radar_mean <- radar_summary(radar_col)

print(radar_mean)


# ---------------------------------------------------------
# 7️⃣ Flood Detection (Thresholding)
# ---------------------------------------------------------
cat("Computing flood mask...\n")

flood_mask <- radar_flood(
  img       = radar_mean,
  threshold = -15,   # Water detection threshold (dB)
  aoi       = ee$Geometry$Rectangle(bbox_test)
)

print(flood_mask)


# ---------------------------------------------------------
# 8️⃣ Extract Mean Values Per Polygon
# ---------------------------------------------------------
cat("Extracting radar values per polygon...\n")

poly_fc <- ee$FeatureCollection(
  ee$Feature(
    ee$Geometry$Rectangle(bbox_test),
    list(name = "TestPolygon")
  )
)

# Extract radar mean values
extracted_radar <- radar_extract_polygons(radar_mean, poly_fc)
print(extracted_radar$first()$getInfo())

# Extract flood mask values (0/1)
extracted_flood <- radar_extract_polygons(flood_mask, poly_fc)
print(extracted_flood$first()$getInfo())


# ---------------------------------------------------------
# 9️⃣ Visualize Results
# ---------------------------------------------------------
cat("Visualizing radar mean...\n")

radar_visualize(
  img     = radar_mean,
  aoi     = ee$Geometry$Rectangle(bbox_test),
  min     = -25,
  max     = 0,
  palette = c("blue", "green", "yellow", "red")
)

cat("Visualizing flood mask...\n")

flood_mask_test <- radar_flood(
  img = radar_mean,
  threshold = -8,   # seuil plus haut
  aoi = ee$Geometry$Rectangle(bbox_test)
)

flood_display <- flood_mask_test$selfMask()

radar_visualize(
  img     = flood_display,
  aoi     = ee$Geometry$Rectangle(bbox_test),
  min     = 0,
  max     = 1,
  palette = c("blue")
)
# =========================================================
# End of Script
# =========================================================