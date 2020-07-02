#CREATING WORD CLOUD
#FIRST YOU NEED TO SAVE THE DF IN TXT FORMAT TO APPLY TEXT MINING
library(Rfacebook)
library(RMySQL)
#LOADING LIBRARIES REQUIRED FOR WORDCLOUD
library(tm)
library(wordcloud)
library(RColorBrewer)

load("my_db_connection")
load("FB_ID_FILE")
load("fb_oauth_auto")
load("fb_oauth_manual")
load("user_id_for_fetch")
options(stringsAsFactors = FALSE)

#FETCHING CATEGORY AND MESSAGE OF USER FEED AND POSTS RESPECTIVELY(ANS /ANS1)
qq1 <- "SELECT post_message FROM "
qq1 <- paste(qq1,fb_user_id_fetch,"_posts",sep = "")

ans <- dbSendQuery(mydb,qq1)
ans <- fetch(ans,n=-1)

qq2 <- "SELECT feed_message FROM "
qq2 <- paste(qq2,fb_user_id_fetch,"_feed",sep = "")

ans1 <- dbSendQuery(mydb,qq2)
ans1 <- fetch(ans1,n=-1)

#SAVING IT IN TEXT FILE FORMAT
write.table(ans,"file_for_cloud1.txt",sep=",")
write.table(ans1,"file_for_cloud2.txt",sep = ",")

#FETCHING THE FILES
f1 <- "C:\\Users\\ASUS\\Documents\\SCI SEM 6\\file_for_cloud1.txt"
f2 <- "C:\\Users\\ASUS\\Documents\\SCI SEM 6\\file_for_cloud2.txt"

#READING THE FILES
r1 <- readLines(f1)
r2 <- readLines(f2)

#CONVERTING THE FILE INTO CORPUS
#Now in order to process or clean the text using tm package, 
#you need to first convert this plain text data into a format called corpus
#which can then be processed by the tm package.

combinetxt <- c(r1,r2)
c1 <- Corpus(VectorSource(combinetxt))


#DATA CLEANING
data<-tm_map(c1,stripWhitespace)
data<-tm_map(data,tolower)
data<-tm_map(data,removeNumbers)
data<-tm_map(data,removePunctuation)
data<-tm_map(data,removeWords, stopwords("english"))

#REMOVING ADDITIONAL WORDS
data<-tm_map(data,removeWords,c("and","the","our","that","for","are","also","more","has","must","have","should","this","with","NA","NULL"))
#str <- paste("C:\\Users\\ASUS\\Documents\\SCI SEM 6\\Photos\\",fb_user_id_fetch,"_wordcloud.png",sep="")

wordcloud(data,scale=c(3.5,.55),max.words=50,random.order=FALSE,rot.per=0.35,use.r.layout=FALSE,colors=brewer.pal(8, "Dark2"))
#dev.off()