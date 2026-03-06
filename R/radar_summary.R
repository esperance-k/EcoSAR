#' Summarize radar ImageCollection
#'
#' Computes a temporal summary (mean) for a selected band
#'
#' @param img_col ee$ImageCollection
#' @param band Band name to summarize (default: first available band)
#' @return ee$Image
#' @export
radar_summary <- function(img_col, band = NULL) {
  # Select first band if none specified
  if (is.null(band)) {
    band <- img_col$first()$bandNames()$getInfo()[1]
  }

  # Select band and compute mean
  img_col$select(band)$mean()
}
