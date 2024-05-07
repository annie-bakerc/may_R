
#### Setup
#Install package: tm
install.packages("tm")
library("tm")

#Install package: wbstats
install.packages('wbstats')
library('wbstats')

#:: = what commands a package has e.g. wbstats::



#Get random number data - normally distributed
random_data <- rnorm(100, mean = 50, sd=10)

#Non normal (uniform) distribution
non_random_data <- 26:125
#: is always combined 'through' (In the US sense e.g. numbers 5:10 = numbers 5 through 10)

#Set a seed: set.seed(12345)
set.seed(12345)

#binding both dataframes into a matrix
data_matrix <- cbind(random_data, non_random_data)

#t-test: to compare the means of min. 2 datasets - e.g. heights of 2 groups, to find out if the difference is significant
t_test_result <- t.test(data_matrix[,1], data_matrix[,2], var.equal = FALSE)
t_test_result

#Interpret t-test 

#above: [rows, columns] -> when one is empty it gets everything, e.g. [,1] = ALL rows, first column

data_matrix[5,1]

### Histograms
###viridis for friendly accessible colours

hist(data_matrix[,1], main = "Histogram of Random Data", xlab = "Random Data Values")
hist(data_matrix[,2], main = "Histogram of Non-Random Data", xlab = "Non-Random Data Values")

hist(random_data, col = "blue", main = "Combined Histogram of Data", xlab = "Data Values", xlim = range(c(random_data, non_random_data)), ylim = c(0, 30), breaks = 20, labels = TRUE, freq = TRUE)
hist(non_random_data, col = "red", add = TRUE, breaks = 20, labels = TRUE, freq = TRUE)
legend("topright", legend = c("Random Data", "Non-Random Data"), fill = c("blue", "red"))


#Country mottos csv
### ./ means within the project
df_mottos <- read.csv("./data/country_mottos.csv", header = TRUE)

#Remove blank space at the start (i.e. to the left)
df_mottos$motto_trimmed <- trimws(df_mottos$motto, which = "left")

#Makes all letters lower case
df_mottos$motto_trimmed <- tolower(df_mottos$motto_trimmed)



#exclude 'stopwords' - the ones without 'lexical' content (eg. with, the, a etc.)
stopwords_list <- stopwords(kind = "en")
stopwords_list

#remove punctuation
df_mottos$motto_trimmed <- gsub("[[:punct:]]", "", df_mottos$motto_trimmed)

df_mottos$motto_trimmed <- trimws(df_mottos$motto_trimmed, which = "both")

df_mottos$motto_clean <- sapply(df_mottos$motto_trimmed, function(line) paste(removeWords(strsplit(line, "\\s+")[[1]], stopwords_list), collapse = " "))

words_list <- unlist(strsplit(df_mottos$motto_clean, "\\s+"))
words_list

word_counts <- sort(table(words_list), decreasing = TRUE)
word_counts
most_common_words <- head(names(word_counts), 10)
most_common_words

df_mottos$motto_trimmed <- ifelse(df_mottos$motto_trimmed == "no official motto", NA, df_mottos$motto_trimmed)

#### LOOK AT THIS LATER AND GO THROUGH STEP BY STEP
#Country mottos csv
### ./ means within the project
df_mottos <- read.csv("./data/country_mottos.csv", header = TRUE)

#Remove blank space at the start (i.e. to the left)
df_mottos$motto_trimmed <- trimws(df_mottos$motto, which = "left")
df_mottos$motto_trimmed <- tolower(df_mottos$motto_trimmed) # lowercase
df_mottos$motto_trimmed <- gsub("[[:punct:]]", "", df_mottos$motto_trimmed)
df_mottos$motto_trimmed <- trimws(df_mottos$motto_trimmed, which = "both")
df_mottos$motto_trimmed <- ifelse(df_mottos$motto_trimmed == "no official motto" | df_mottos$motto_trimmed == "no official national motto", "", df_mottos$motto_trimmed)
stopwords_list <- stopwords(kind = "en")  		# Get English stopwords
df_mottos$motto_clean <- sapply(df_mottos$motto_trimmed, function(line) paste(removeWords(strsplit(line, "\\s+")[[1]], stopwords_list), collapse = " "))
df_mottos$motto_clean <- gsub("\\s+", " ", df_mottos$motto_clean)

#Look at most common words
words_list <- unlist(strsplit(df_mottos$motto_clean, "\\s+"))
word_counts <- sort(table(words_list), decreasing = TRUE)
most_common_words <- names(word_counts)[2:5]


#Loop!
#Adds 4 columns to show which languages have each of the 4 words (1 or 0 for each language)
for (word in most_common_words) {
  df_mottos[paste("has", word, sep = "_")] <-
    as.integer(grepl(word, df_mottos$motto_clean))
}


#See which ones have none (new column with 1 or 0)

df_mottos$has_none <- ifelse(df_mottos$motto_clean == "", 1, 0)


###########################################################################################

#Search from world bank
wbgdp <- wb_search("GDP per capita")
wblifeex <- wb_search("life expectancy")

#Can search between specifi dates too
df_gdp <- wb_data("NY.GDP.PCAP.KD", start_date = 2020, end_date = 2020)
df_lex <- wb_data("SP.DYN.LE00.IN", start_date = 2020, end_date = 2020)















