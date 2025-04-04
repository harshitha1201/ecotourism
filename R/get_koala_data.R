#' Load Koala Data
#'
#' This function loads the koala occurrence dataset from the package's `inst/extdata/` folder.
#'
#' @return A data frame containing koala occurrence records.
#' @export
#' @examples
#' \dontrun{
#' koala_data <- get_koala_data()
#' }
get_koala_data <- function() {
  readr::read_csv(system.file("extdata", "koala_data.csv", package = "ecotourism"))
}
