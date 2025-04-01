library(galah)
library(dplyr)

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

