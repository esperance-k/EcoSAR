#' Visualize radar image in Earth Engine Map
#' @export
radar_visualize <- function(img, aoi = NULL, band = NULL,
                            palette = c("black","blue","green","yellow","red"),
                            min = NULL, max = NULL) {

  if ("ImageCollection" %in% class(img)) {
    img <- img$mean()
  }

  if (is.null(band)) {
    band <- img$bandNames()$getInfo()[1]
  }

  img_clip <- if (!is.null(aoi)) img$clip(aoi) else img

  if (!is.null(aoi)) {
    rgee::Map$centerObject(aoi)
  }

  rgee::Map$addLayer(
    eeObject = img_clip$select(band),
    visParams = list(min = min, max = max, palette = palette),
    name = paste("Radar -", band)
  )

}
