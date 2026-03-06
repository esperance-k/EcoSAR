#' Load Sentinel-1 SAR ImageCollection
#'
#' @param start_date Start date (YYYY-MM-DD)
#' @param end_date End date (YYYY-MM-DD)
#' @param bbox Bounding box as c(xmin, ymin, xmax, ymax)
#' @param polarization Polarization type ("VV" or "VH")
#' @return ee$ImageCollection
#' @export
radar_load <- function(start_date, end_date, bbox, polarization = "VV") {
  library(rgee)

  aoi <- ee$Geometry$Rectangle(bbox)

  s1_col <- ee$ImageCollection("COPERNICUS/S1_GRD")$
    filterDate(start_date, end_date)$
    filterBounds(aoi)$
    filter(ee$Filter$listContains("transmitterReceiverPolarisation", polarization))$
    filter(ee$Filter$eq("instrumentMode", "IW"))

  return(s1_col)
}
