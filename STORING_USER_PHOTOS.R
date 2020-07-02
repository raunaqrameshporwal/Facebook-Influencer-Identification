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

#CREATING TABLE
q1 <- "CREATE TABLE "
q1 <- paste(q1,fb_user_id_fetch,"_photos",sep="")
q2 <- "(Friend_name varchar(100),Friend_id bigint(50),photo_link longtext)"
q2 <- paste(q1,q2,sep = "")
dbSendQuery(mydb,q2)

#FORMING HTTP QUERY
qA1 <- "https://graph.facebook.com/v2.12/"
qA2 <- "?fields=photos%7Bfrom%2Cpicture%7D&access_token="
httpquery <- paste(qA1,fb_user_id,qA2,fb_oauth_manual,sep = "")
httpquery
#CALLING API AND PARSING

result <- GET(httpquery) %>% stop_for_status()
result <- parse_content(result)
#names(result$photos$data$picture)
#result <- as.data.frame(result)
#CHANGING NAMES TO MAKE IT EVEN WITH THE NAMES OF NEXT PAGE
#colnames(result) <-c("data.from","data.picture","data.id","paging.cursors.before","paging.cursors.after","paging.next","paging.previous")


#FUNCTION FOR INSERT 
insert_photo_into_db <- function (df)
{
  
  i<- 1
    while(i<=length(df$data$id))
  {
    qt1 <- "INSERT INTO "
    qt2 <- paste(qt1,fb_user_id_fetch,"_photos VALUES(",sep = "")
    from_name <- df$data$from$name[i]
    from_name <- remove_double_quotes(from_name)
    from_name <- remove_single_quotes(from_name)
    from_name <-remove_character_quotes(from_name)
    from_id   <- df$data$from$id[i]
    pic_link <- df$data$picture[i]
    final_query <-paste(qt2,"'",from_name,"',",from_id,",'",pic_link,"')",sep = "")
    
    dbSendQuery(mydb,final_query)
    i <- i+1
    
    }

}

#SENDING FIRST PAGE
insert_photo_into_db(result$photos)

#FIRST NEXT PAGE
if(!is.null(result$photos$paging$'next'))
  {

next_page <- result$photos$paging$'next'


#LOOPING THROUGH NEXT PAGES UNTIL LAST
 

while(!is.null(next_page))
{
  result_next <- GET(next_page) %>% stop_for_status()
  next_parsedd <-parse_content(result_next)
  insert_photo_into_db(next_parsedd)
  next_page <- next_parsedd$paging$'next'
  
}
}


