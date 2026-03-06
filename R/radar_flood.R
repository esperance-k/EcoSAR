#' Detect flood areas from radar image
#'
#' @param img ee$Image or ee$ImageCollection
#' @param threshold Threshold in dB to classify water (default -15)
#' @param aoi ee$Geometry (optional)
#' @return ee$Image Mask where water = 1
#' @export
radar_flood <- function(img, threshold = -15, aoi = NULL) {

  # Compute mean if ImageCollection
  if ("ImageCollection" %in% class(img)) {
    img <- img$mean()
  }

  # Convert to dB
  img_db <- img$log10()$multiply(10)

  # Create water mask
  water_mask <- img_db$lt(threshold)

  # Clip to AOI if provided
  if (!is.null(aoi)) {
    water_mask <- water_mask$clip(aoi)
  }

  return(water_mask)
}
