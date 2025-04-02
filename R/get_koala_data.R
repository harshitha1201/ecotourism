#library(galah)
#library(dplyr)

# Declare global variables to avoid NOTE in `R CMD check`
utils::globalVariables(c(
  "year", "basisOfRecord", "stateProvince", "decimalLatitude",
  "decimalLongitude", "eventDate", "individualCount", "cl1048"
))

#' Fetch Koala occurrence data from the Atlas of Living Australia (ALA)
#'
#' This function retrieves Koala (Phascolarctos cinereus) occurrence records from the ALA
#' for the years 2023-2024, filtered by state and with quality controls. It joins the
#' occurrence data with conservation status information for each state.
#'
#' @param user_email A string containing the user's email for configuring ALA data access
#'
#' @returns A tibble (data frame) containing Koala occurrence records with the following columns:
#' \itemize{
#'   \item eventDate: Date of observation (Date object)
#'   \item decimalLatitude: Latitude in decimal degrees (numeric, double)
#'   \item decimalLongitude: Longitude in decimal degrees (numeric, double)
#'   \item individualCount: Number of individuals observed (numeric, double; may contain NA values)
#'   \item stateProvince: Australian state where observation occurred (character)
#'   \item habitat_type: Type of habitat (character, from ALA's cl1048 field)
#'   \item status: Conservation status in the state (character)
#'   \item source: Legislative source for conservation status (character)
#'   \item assessment_year: Year of conservation status assessment (numeric, double)
#' }
#'
#' @examples
#' koala_data <- get_koala_data("harshithadiddige24@gmail.com")
#' head(koala_data)
#'
#' @importFrom galah galah_config galah_call galah_identify galah_filter galah_select atlas_occurrences
#' @importFrom dplyr rename mutate filter left_join %>%
#' @export
get_koala_data <- function(user_email) {

  galah_config(email = user_email)

  koala_data <- galah_call() %>%
    galah_identify("Phascolarctos cinereus") %>%
    galah_filter(year >= 2023,
                 basisOfRecord %in% c("HumanObservation", "MachineObservation"),
                 stateProvince %in% c("Queensland", "New South Wales", "South Australia", "Victoria"),
                 !is.na(decimalLatitude),
                 !is.na(decimalLongitude)) %>%
    galah_select(eventDate, decimalLatitude, decimalLongitude, individualCount, stateProvince, cl1048) %>%
    atlas_occurrences()

  koala_data <- koala_data %>%
    rename(habitat_type = cl1048) %>%
    mutate(eventDate = as.Date(eventDate)) %>%
    filter(eventDate >= as.Date("2023-01-01") & eventDate <= as.Date("2024-12-31"))

  conservation_status <- data.frame(
    stateProvince = c("New South Wales", "Queensland", "Victoria", "South Australia"),
    status = c("Endangered", "Vulnerable", "Vulnerable", "Rare"),
    source = c(
      "NSW BC Act 2016",
      "QLD NC Act 1992",
      "VIC FFG Act 1988",
      "SA NPW Act 1972"
    ),
    assessment_year = c(2021, 2020, 2021, 2019)
  )

  koala_data <- koala_data |> left_join(conservation_status, by = "stateProvince")

  return(koala_data)
}
