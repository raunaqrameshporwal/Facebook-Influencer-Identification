library(Rfacebook)
library(RCurl)
library(magrittr)
library(httr)
library(RMySQL)
library(jsonlite)
load("my_db_connection")
load("FB_ID_FILE")
load("fb_oauth_auto")
load("fb_oauth_manual")
options(stringsAsFactors = FALSE)

#STORING POSTS FOR WORD CLOUD



#FORMING HTTP QUERY
query1 <- "https://graph.facebook.com/v2.12/"
query2 <- "?fields=id%2Cname%2Cposts%7Bmessage%2Cstory%2Ccreated_time%7D&access_token="
httpquery <- paste(query1,fb_user_id,query2,fb_oauth_manual,sep = "")
httpquery


#CREATING A TABLE IN DB
q1 <- "CREATE TABLE "
q2 <- paste(q1,fb_user_id_fetch,"_","posts"," ","(",sep = "")
q3 <-paste(q2,"post_story varchar(10000),post_message varchar(10000),created_time varchar(100)",")",sep ="")
dbSendQuery(mydb,q3)

#FUNCTION TO INSERT INTO DB
insert_feed <- function(df)
{
  i<-1
  while(i<=length(df$id))
  {
    q1 <-paste("INSERT INTO ",fb_user_id_fetch,"_","posts"," ","VALUES('",sep = "")
    if(!is.null(df[i,"story"]))
    {
      df[i,"story"] <- remove_double_quotes(df[i,"story"])
      df[i,"story"] <- remove_single_quotes(df[i,"story"])
      df[i,"story"] <- remove_character_quotes(df[i,"story"])
      
    }
    if(!is.null(df[i,"message"]))
    {
      df[i,"message"] <- remove_double_quotes(df[i,"message"])
      df[i,"message"] <- remove_single_quotes(df[i,"message"])
      df[i,"message"] <- remove_character_quotes(df[i,"message"])
      
    }
    
    q2 <-paste(q1,df[i,"story"],"',","'",df[i,"message"],"',","'",df[i,"created_time"],"')",sep = "")
    dbSendQuery(mydb,q2)
    i <- i+1
  }
}



#FETCHING FIRST PAGE
result_firstpage <- GET(httpquery) %>% stop_for_status()
result_firstpage <- parse_content(result_firstpage)



#SENDING FIRST PAGE INTO DB
insert_feed(result_firstpage$posts$data)

#FETCHING NEXT PAGES
next_page <- result_firstpage$posts$paging$'next'
next_page
if(!is.null(next_page))
{
while(!is.null(next_page))
{
  result_nextpage <- GET(next_page) %>% stop_for_status()
  result_nextpage <- parse_content(result_nextpage)
  names(result_nextpage$data)
  insert_feed(result_nextpage$data)
  
  #FETCHING NEXT PAGE
  next_page <- result_nextpage$paging$'next'
}
}


