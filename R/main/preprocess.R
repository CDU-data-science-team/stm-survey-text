################################################################################
## Title: preprocess
## Last Update: 11/07/2022
## Version: 1.0
## Developer Contact: analytics-unit@nhsx.nhs.uk
################################################################################

# ------------ Data pre-processing ------------------------
sapply(data, class)
summary(data)

#stopwords

if(!exists("highFreq")){
  
  highFreq <- NULL
}

mystopwords <- c(stopwords('en'), highFreq)

# Idenitfy columns that contain missing values, then idenitfy the rows with
# these missing values.
data[rowSums(is.na(data)) > 0, ]

# Summary of text data length
text_length(data$Response)

# Split data training set and test set. The test set is retained to validate the
# method at the end of development.  
set.seed(1)
sample <- sample(nrow(data), ceiling(nrow(data)/20))
test_set <- data[sample, ]
train_set <- data[-sample, ]

# ------------ Sentiment Analysis ------------------------
# Vader is used to perform sentiment analysis on the text and adds a column to
# the dataframe with the sentiment scores. The can be run and saved using the
# following code. This can take a long time, so the sentiment score has been
# saved and can be read in using the following code (commented out).
train_set <- sentAnalysis(train_set$Response, train_set)

# ------------ Cleaning and pre-processing data ------------------------

#From the training set, remove rows with NAs values and explicitly specify the
#data types of variables. This is dataset specific. Outliers of the
#"criticality" variable are imputed to be between -4 and 4 The variables are
#categorised as numeric, factors (for categorical data), or character strings.
train_set <- prep_dataframe(train_set)

# The feedback responses ("feedback") is cleaned and pre-processed to be used
# for the topic modelling. A corpus of is generated and the metadata is
# re-associated with the text The text is made lower case, contractions, such as
# "won't", are expanded, digits and punctuation removed, stopwords removed and
# text is tokenised. The text_cleaned object produced contains
# text_cleaned$Tokens which is the text tokenised and text_cleaned$DocMatrix,
# which is the document- feature matrix.
text_cleaned <- clean_text(train_set,StopWords = mystopwords)

# The document feature matrix is coverted to a format that is used by stm 
# package.
stmdata <- convert_to_stm(text_cleaned$DocMatrix, train_set)

# Plot of the distribution of tokens per document in the pre-processed text. 
w <- rowSums(text_cleaned$DocMatrix)
barplot(w,
        las = 2,
        ylab = "Number of Tokens", main = "Tokens per Document")

boxplot(w, xlab = "Number of Tokens", horizontal = TRUE, 
        main = "Boxplot of Number of Tokens per Document")

# The data is processed and can be used with stm package. The model selection
# is done using `model.R`.

