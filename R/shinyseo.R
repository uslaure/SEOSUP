#' shinyseo
#'
#' shiny app for serp
#' @importFrom shiny runApp
#' @export
#' @examples
#' #SEO::shinyseo()
shinyseo <- function() {
  appDir <- system.file("shinyseo", "shinyseo", package = "SEO")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `SEO`.", call. = FALSE)
  }

  runApp(appDir, display.mode = "normal")
}


