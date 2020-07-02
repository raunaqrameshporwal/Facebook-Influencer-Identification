library(RMySQL)
library(magrittr)
library(httr)
library(jsonlite)
library(RCurl)
library(Rfacebook)
load("my_db_connection")
load("FB_ID_FILE")
load("fb_oauth_auto")
load("fb_oauth_manual")
options(stringsAsFactors = FALSE)


#FORMING HTTP QUERY
query1 <- "https://graph.facebook.com/v2.12/"
query2 <- "?fields=feed.limit(500000)%7Bstory%2Ccreated_time%2Cmessage%7D&access_token="
httpquery <- paste(query1,fb_user_id,query2,fb_oauth_manual,sep = "")



#CREATING A TABLE IN DB
q1 <- "CREATE TABLE "
q2 <- paste(q1,fb_user_id_fetch,"_","feed"," ","(",sep = "")
q3 <-paste(q2,"feed_story varchar(10000),feed_message varchar(10000),created_time varchar(100)",")",sep ="")
dbSendQuery(mydb,q3)

#FUNCTION TO INSERT INTO DB
insert_feed <- function(df)
{
  i<-1
  while(i<=nrow(df))
  {
    q1 <-paste("INSERT INTO ",fb_user_id_fetch,"_","feed"," ","VALUES('",sep = "")
    if(!is.null(df[i,"feed.data.story"]))
    {
          df[i,"feed.data.story"] <- remove_double_quotes(df[i,"feed.data.story"])
          df[i,"feed.data.story"] <- remove_single_quotes(df[i,"feed.data.story"])
          df[i,"feed.data.story"] <- remove_character_quotes(df[i,"feed.data.story"])
         
    }
    if(!is.null(df[i,"feed.data.message"]))
    {
      df[i,"feed.data.message"] <- remove_double_quotes(df[i,"feed.data.message"])
      df[i,"feed.data.message"] <- remove_single_quotes(df[i,"feed.data.message"])
      df[i,"feed.data.message"] <- remove_character_quotes(df[i,"feed.data.message"])
      
       }
    
    q2 <-paste(q1,df[i,"feed.data.story"],"',","'",df[i,"feed.data.message"],"',","'",df[i,"feed.data.created_time"],"')",sep = "")
    dbSendQuery(mydb,q2)
    i <- i+1
  }
}



#FETCHING FIRST PAGE
result_firstpage <- GET(httpquery) %>% stop_for_status()
result_firstpage <- parse_content(result_firstpage)
result_firstpage <- as.data.frame(result_firstpage)


#SENDING FIRST PAGE INTO DB
insert_feed(result_firstpage)

#FETCHING NEXT PAGES
next_page <- result_firstpage[1,6]

while(!is.null(next_page))
{
  result_nextpage <- GET(next_page) %>% stop_for_status()
  result_nextpage <- parse_content(result_nextpage)
  
  #Next page to in data frame to be inserted in db
  next_page_insert <- as.data.frame(result_nextpage$data)
  insert_feed(next_page_insert)
  
  #FETCHING NEXT PAGE
  next_page <- result_nextpage$paging$'next'
  }

