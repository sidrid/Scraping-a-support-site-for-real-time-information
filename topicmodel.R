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
tdm = DocumentTermMatrix(corpus) # Creating a Term document Matrix
# create tf-idf matrix
term_tfidf <- tapply(tdm$v/row_sums(tdm)[tdm$i], tdm$j, mean) * log2(nDocs(tdm)/col_sums(tdm > 0))
summary(term_tfidf)
tdm <- tdm[,term_tfidf >= 0.1]
tdm <- tdm[row_sums(tdm) > 0,]
summary(col_sums(tdm))
#Deciding best K value using Log-likelihood method
best.model <- lapply(seq(2, 50, by = 1), function(d){LDA(tdm, d)})
best.model.logLik <- as.data.frame(as.matrix(lapply(best.model, logLik)))
#calculating LDA
k = 10;#number of topics
SEED = 150; # number of tweets used
CSC_TM <-list(VEM = LDA(tdm, k = k, control = list(seed = SEED)),VEM_fixed = LDA(tdm, k = k,control = list(estimate.alpha = FALSE, seed = SEED)),Gibbs = LDA(tdm, k = k, method = "Gibbs",control = list(seed = SEED, burnin = 1000,thin = 100, iter = 1000)),CTM = CTM(tdm, k = k,control = list(seed = SEED,var = list(tol = 10^-4), em = list(tol = 10^-3))))
#To compare the fitted models we first investigate the values of the models fitted with VEM and estimated and with VEM and fixed 
sapply(CSC_TM[1:2], slot, "alpha")
sapply(CSC_TM, function(x) mean(apply(posterior(x)$topics, 1, function(z) - sum(z * log(z)))))
Topic <- topics(CSC_TM[["VEM"]], 1)
Terms <- terms(CSC_TM[["VEM"]], 5)
Terms