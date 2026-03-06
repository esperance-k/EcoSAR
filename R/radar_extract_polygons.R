#' Extract mean radar values per polygon
#'
#' @param img ee$Image
#' @param polygons ee$FeatureCollection
#' @param scale Scale in meters (default 10)
#' @return ee$FeatureCollection
#' @export
radar_extract_polygons <- function(img, polygons, scale = 10) {
  img$reduceRegions(
    collection = polygons,
    reducer = ee$Reducer$mean(),
    scale = scale
  )
}
