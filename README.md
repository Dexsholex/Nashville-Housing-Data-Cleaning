# Cleaning Nashville Housing Dataset.

## Overview
The goal of the project is to clean the Nashville housing dataset to a format that is ready to be explore/process. 

The original data set can be found here: https://www.kaggle.com/tmthyjames/nashville-housing-data-1/data


## Details
- The sale_date column was standardize to date from January 04, 2018 format to 'YYYY-MM-DD' .
- The property address column was populated with address of simialr parcel id.
- The property and owner column was splitted out into Individual Column (Address, City, State). 
- Change Y or N to Yes and No in sold_as_vacant column.


## Tools
- SQL