
# load libraries ----------------------------------------------------------
library(tidyverse)
library(httr)
library(rvest)
library(jsonlite)


response <-  httr::GET(
  url = "https://api.gdeltproject.org/api/v2/doc/doc?query=%22endometriosis%22&mode=artlist&maxrecords=100&timespan=1week",
  verbose()
)

response <- httr::GET(
  url = "https://api.gdeltproject.org/api/v2/doc/doc",
  query = list(
    query = "endometriosis",
    mode = "artlist",
    maxrecords = 250,
    timespan = "3months",
    format = "json"
  )
)
data <- content(response, as = "parsed")

# 2. Extract the content as text
# We use 'as = "text"' so jsonlite can read it properly
raw_json <- content(response, as = "text", encoding = "UTF-8")

# 3. Convert JSON text into an R List
data_list <- fromJSON(raw_json)

# 4. Extract just the 'articles' part into a Data Frame
# GDELT puts the list of articles inside a slot called "articles"
articles_df <- as.data.frame(data_list$articles)

# 5. Look at your results!
print(head(articles_df))



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
