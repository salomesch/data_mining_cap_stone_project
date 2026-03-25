# Data Mining Project Template

This repository contains the code for a small data mining project developed as part of the course:

**Data Access and Data Mining for Social Sciences**

University of Lucerne

Salome Schwegler  
Course: Data Mining for the Social Sciences using R
Term: Spring 2026

## Project Goal

The goal of this project is to collect and analyze data from an online source (API or web scraping) in order to answer a research question relevant to political or social science.

The project should demonstrate:

- Identification of a suitable data source
- Automated data collection (API or scraping)
- Data cleaning and preparation
- Reproducible analysis


## Research Question

Which countries print the most articles about Endometriosis?
How is the general sentiment of news articles about Endometriosis?

I adjusted my research question, because the full text API on GDELT can only extract articles form the past 3 months. 

## Data Source

Describe the data source here.

Example:

- API: https://api.gdeltproject.org/api/v2/doc/doc?query=%22endometriosis%22&mode=artlist&maxrecords=100&timespan=1week
- Documentation: https://blog.gdeltproject.org/gdelt-doc-2-0-api-debuts/ 
- Access method: HTTP GET requests


## Repository Structure

/code     scripts used to collect/process data
/data     output datasets (not tracked/pushed by git)
README.md   project description


## Reproducibility

To reproduce this project:

1. Clone the repository
2. Install required R packages
3. Run the scripts in the `code/` folder

All data should be generated automatically by the scripts.


## Good Practices

Please follow these guidelines:

- Do **not upload raw datasets** to GitHub.
- Store **API keys outside the repository** (e.g., environment variables).
- Write scripts that run **from start to finish**.
- Commit your work **frequently**.
- Use **clear commit messages**.

Example commit messages:
added API request
cleaned dataset structure
added visualization
fixed JSON parsing


## Notes

Large datasets should not be pushed to GitHub.  
If necessary, provide instructions for downloading the data instead.
