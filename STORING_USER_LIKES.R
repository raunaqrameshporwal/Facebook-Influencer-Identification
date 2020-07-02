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

#FORMING QUERY AND CONCATENATING IT WITH ACCESS TOKEN TO FORM FINAL QUERY
query1 <- "https://graph.facebook.com/v2.12/"
query2 <-"?fields=id%2Cname%2Clikes.limit(500000)%7Bcategory%2Cname%7D&access_token="
httpquery <- paste(query1,fb_user_id,query2,fb_oauth_manual,sep = "")
httpquery

#STOP FOR STATUS CONVERTS HTTP ERROR INTO 'R' ERROR if any
#FETCHING FIRST PAGE IN CASE OF MULTIPLE PAGES
r1.result <- GET(httpquery) %>% stop_for_status()
r1.result

#PARSING THE FIRST PAGE
parsed_result <- parse_content(r1.result)
parsed_result

#CREATING A LIKE TABLE
q1 <- "CREATE TABLE"
q2 <-"(name varchar(100),category varchar(100))"
sqltabletemp <- paste(q1,parsed_result$id)
sqltabletemp <-paste(sqltabletemp,"_","likes",sep="")
sqltabletemp <-paste(sqltabletemp,q2,sep="")
dbSendQuery(mydb,sqltabletemp)

#FUNCTION TO INSERT INTO TABLE
insert_likes <- function(df)
  {
   i <- 1
   while(i<=(nrow(df)))
   {
     table_query1 <-paste("INSERT INTO ",parsed_result$id,"_","likes",sep="")
     
     # CALLING A FUNCTION TO REMOVE " from strings if any and replacing it with a space
     df[i,"name"] <-remove_double_quotes(df[i,"name"])
     df[i,"category"] <-remove_double_quotes(df[i,"category"])
     
     #CALLING A FUNCTION TO REMOVE ' from string if any and replacaing with a space
     df[i,"name"] <-remove_single_quotes(df[i,"name"])
     df[i,"category"] <-remove_double_quotes(df[i,"category"])
     
     #CALLING A FUNCTION TO REMOVE multiple characters from string if any and replacaing with a space
     df[i,"name"] <-remove_character_quotes(df[i,"name"])
     df[i,"category"] <-remove_character_quotes(df[i,"category"])
     
     
     table_query2 <- paste('VALUES("',df[i,"name"],'"',',"',df[i,"category"],'")',sep="")
     table_final_query <- paste(table_query1,table_query2)
     dbSendQuery(mydb,table_final_query)
     i <- i+1
     
   }
  
}

#INSERTING INTO DB FIRST PAGE
df_firsttable <- as.data.frame(parsed_result$likes$data) 
names(df_firsttable)
#CONVERTING INTO Data frame for easy access
insert_likes(df_firsttable)

#NEXT PAGE URL FETCHING
next_page <- parsed_result$likes$paging$'next'


#LOOP FOR FETCHING IN CASE OF MULTILPE PAGES OF REPLY
 while(!is.null(next_page))
   {
  more_results <- GET(next_page) %>% stop_for_status()
  more_parsed <- parse_content(more_results)
  
  #cause names() of multiple page is different than first page
  df_multiple_pages <- as.data.frame(more_parsed$data)
  
  #Calling insert like
  insert_likes(df_multiple_pages)
  
  #FETCHING NEXT PAGE
  next_page <- more_parsed$paging$'next'
  
  }


