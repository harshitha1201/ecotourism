library(galah)
library(dplyr)
library(readr)

galah_config(email = "harshithadiddige24@gmail.com")

koala_data <- galah_call() %>%
  galah_identify("Phascolarctos cinereus") %>%
  galah_filter(year >= 2023,
               basisOfRecord %in% c("HumanObservation", "MachineObservation"),
               stateProvince %in% c("Queensland", "New South Wales", "South Australia", "Victoria"),
               !is.na(decimalLatitude),
               !is.na(decimalLongitude)
  ) %>%
  galah_select(eventDate, decimalLatitude, decimalLongitude, stateProvince, cl1048) %>%
  atlas_occurrences()

koala_data <- galah_call() %>%
  galah_identify("Phascolarctos cinereus") %>%
  galah_filter(year >= 2023,
               basisOfRecord %in% c("HumanObservation", "MachineObservation"),
               stateProvince %in% c("Queensland", "New South Wales", "South Australia", "Victoria"),
               !is.na(decimalLatitude),
               !is.na(decimalLongitude)
  ) %>%
  galah_select(eventDate, decimalLatitude, decimalLongitude, individualCount, stateProvince, cl1048) %>%
  atlas_occurrences()

# Rename and mutate columns
koala_data <- koala_data %>%
  rename(habitat_type = cl1048) %>%
  mutate(eventDate = as.Date(eventDate)) %>%
  filter(
    eventDate >= as.Date("2023-01-01") & eventDate <= as.Date("2024-12-31"),
    !is.na(individualCount)  # Filter out rows with NA in individualCount
  )

conservation_status <- data.frame(
  stateProvince	 = c("New South Wales", "Queensland", "Victoria", "South Australia"),
  conservation_status = c("Endangered", "Vulnerable", "Vulnerable", "Rare"),
  conservation_source = c(
    "NSW BC Act 2016",
    "QLD NC Act 1992",
    "VIC FFG Act 1988",
    "SA NPW Act 1972"
  )
)

koala_data <- koala_data |>
  left_join(conservation_status, by = "stateProvince")  # Ensure 'region' column matches

# Save the koala_data DataFrame to a CSV file
write_csv(koala_data, here::here("inst", "extdata", "koala_data.csv"))
