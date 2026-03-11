
# load libraries ----------------------------------------------------------
library(tidyverse)
library(httr)
library(rvest)
library(jsonlite)


response <-  httr::GET(
  url = "https://api.gdeltproject.org/api/v2/doc/doc?query=%22endometriosis%22&mode=artlist&maxrecords=100&timespan=1week",
  verbose()
)

Sys.sleep(6)
response <- httr::GET(
  url = "https://api.gdeltproject.org/api/v2/doc/doc",
  query = list(
    query = "endometriosis",
    mode = "artlist",
    maxrecords = 250,
    timespan = "3weeks",
    format = "json"
  )
)
data <- content(response, as = "parsed")


# Create empty vectors where to store the codes and names:
out_url <- vector(mode = "character", length = length(data$articles))
out_title <- vector(mode = "character", length = length(data$articles))
out_sourcecountry <- vector(mode = "character", length = length(data$sourcecountry))

# Now loop to extract all codes/names from the list:
for (i in 1:length(data$articles)){
  out_url[i] <- data$articles[[i]]$url
  out_title[i] <- data$articles[[i]]$title
  out_sourcecountry[i] <- data$articles[[i]]$sourcecountry
}

# 5. Convert into a tidy tibble --------------------
variables_dataset = tibble(
  url = out_url, 
  title = out_title,
  country = out_sourcecountry
)

# save variable data set
saveRDS(variables_dataset, "data_raw/variable_dataset.rds")
variables_dataset <- readRDS("data_raw/variable_dataset.rds")


