

############# DATA IMPORT SCRIPT ############# 
## This was run May 3rd 2024 (03.05.2024)

#### Setup
#Install package: tm
#install.packages("tm")
#library("tm")

#Install package: wbstats
install.packages('wbstats')
library('wbstats')

#Install package: pacman (checks if something already exists e.g. if tidyverse is already installed)
install.packages('pacman')
library('pacman')

install.packages('tidyverse')
library('tidyverse')
#Check/load packages
p_load('tidyverse', 'tm', 'countrycode')

install.packages('countrycode')
library(countrycode)

#Install package: tidyverse

################# SCRIPTS ####################  

#Scraped from Wikipedia 
df_mottos$motto_trimmed <- trimws(df_mottos$motto, which = "left")
df_mottos$motto_trimmed <- tolower(df_mottos$motto_trimmed) # lowercase
df_mottos$motto_trimmed <- gsub("[[:punct:]]", "", df_mottos$motto_trimmed)
df_mottos$motto_trimmed <- trimws(df_mottos$motto_trimmed, which = "both")
df_mottos$motto_trimmed <- ifelse(df_mottos$motto_trimmed == "no official motto" | df_mottos$motto_trimmed == "no official national motto", "", df_mottos$motto_trimmed)
stopwords_list <- stopwords(kind = "en")  		# Get English stopwords
df_mottos$motto_clean <- sapply(df_mottos$motto_trimmed, function(line) paste(removeWords(strsplit(line, "\\s+")[[1]], stopwords_list), collapse = " "))
df_mottos$motto_clean <- gsub("\\s+", " ", df_mottos$motto_clean)

#Cleaning up Wikipedia data (tidyverse)
df_mottos <- df_mottos %>% mutate(motto_trimmed = trimws(motto, which = "both"), 
                                  tolower(motto_trimmed), gsub("[[:punct:]]", "",motto_trimmed))
                                  ifelse(motto_trimmed == "no official motto", "", motto_trimmed) ifelse(motto_trimmed == "no official national motto", "", motto_trimmed)


#Scraped from World Bank

#Search & import
wbgdp <- wb_search("GDP per capita")
wblifeex <- wb_search("life expectancy")

#Can search between specific dates too
df_gdp <- wb_data("NY.GDP.PCAP.KD", start_date = 2020, end_date = 2020)
df_lex <- wb_data("SP.DYN.LE00.IN", start_date = 2020, end_date = 2020)


