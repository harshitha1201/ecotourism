#' Koala Occurrence Data (2023-2024)
#'
#' This dataset contains koala occurrence records from 2023-2024,
#' filtered from the Atlas of Living Australia.
#'
#' @format A data frame with the following columns:
#' \describe{
#'   \item{eventDate}{Date of observation (Date object)}
#'   \item{decimalLatitude}{Latitude in decimal degrees (numeric, double)}
#'   \item{decimalLongitude}{Longitude in decimal degrees (numeric, double)}
#'   \item{individualCount}{Number of individuals observed (numeric, double; may contain NA values)}
#'   \item{stateProvince}{Australian state where observation occurred (character)}
#'   \item{habitat_type}{Type of habitat (character, from ALA's cl1048 field)}
#'   \item{conservation_status}{Conservation status in the state (character)}
#'   \item{conservation_source}{Legislative source for conservation status (character)}
#' }
#'
#' @source \url{https://www.ala.org.au}
"koala_data"



