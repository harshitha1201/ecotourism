fetch_koala_data <- function() {
  readr::read_csv(system.file("extdata", "koala_data.csv", package = "ecotourism"))
}
