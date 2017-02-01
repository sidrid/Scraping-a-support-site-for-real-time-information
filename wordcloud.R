library("tm")
library("wordcloud")
library("slam")
library("topicmodels")
library("SnowballC")
##con <- file("iphonestats.csv", "rt")
con <- read.csv("iphonestats.csv",stringsAsFactors=FALSE)
tweets = con$Comments
tweets
#Clean Text
tweets = gsub("(RT|via)((?:\\b\\W*@\\w+)+)","",tweets)
tweets = gsub("http[^[:blank:]]+", "", tweets)
tweets = gsub("@\\w+", "", tweets)
tweets = gsub("[ \t]{2,}", "", tweets)
tweets = gsub("^\\s+|\\s+$", "", tweets)
tweets <- gsub('\\d+', '', tweets)
tweets = gsub("[[:punct:]]", " ", tweets)
corpus = Corpus(VectorSource(tweets))
corpus

corpus[[1]]
corpus = tm_map(corpus, content_transformer(tolower))
corpus = tm_map(corpus, PlainTextDocument)
corpus = tm_map(corpus,removePunctuation)
corpus = tm_map(corpus,stripWhitespace)
corpus = tm_map(corpus,tolower)
corpus = tm_map(corpus,removeWords,stopwords("english"))
corpus = tm_map(corpus, stemDocument)
corpus = tm_map(corpus, PlainTextDocument)
frequencies = DocumentTermMatrix(corpus) # Creating a Term document Matrix

library(caTools)
library(rpart)
library(rpart.plot)
library(wordcloud)
library(RColorBrewer)

allTweets = as.data.frame(as.matrix(frequencies))
str(allTweets)
summary(allTweets)
library(wordcloud)
colnames(allTweets)
colSums(allTweets)
library(RColorBrewer)

display.brewer.all() 
?brewer.pal
wordcloud(colnames(allTweets),
          colSums(allTweets),
          min.freq = 3,
          random.order=FALSE,
          colors=c("red", "green", "blue")
)
wordcloud(colnames(allTweets),
          colSums(allTweets),
          min.freq = 3,
          random.order=FALSE,
          colors=brewer.pal(3,"Spectral")   # Spectral
)

wordcloud(colnames(allTweets),
          colSums(allTweets),
          min.freq = 3,
          random.order=FALSE,
          colors=brewer.pal(9, "Blues")[c(1, 2, 3, 4)]     #  or [c(-1, -2, -3, -4)]   
)

?wordcloud
