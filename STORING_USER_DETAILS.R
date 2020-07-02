library(Rfacebook)
library(RCurl)
library(jsonlite)
library(httr)
library(RMySQL)
library(magrittr)
load("my_db_connection")
load("FB_ID_FILE")
load("fb_oauth_auto")
load("fb_oauth_manual")
options(stringsAsFactors = FALSE)

#FORMING QUERY AND CONCATENATING IT WITH ACCESS TOKEN TO FORM FINAL QUERY
query1 <- "https://graph.facebook.com/v2.12/"
query2 <-"?fields=last_name%2Cfirst_name%2Cemail%2Clocation%2Cgender&access_token="
httpquery <- paste(query1,fb_user_id,query2,fb_oauth_manual,sep = "")

#QUERYING IT AND STORING RESPONSE
r.result <- GET(httpquery) %>% stop_for_status()


#CONVERTING THE RESPONSE OBJECT INTO ENCODED TEXT(CHARACTER CLASS)
content <- content(r.result,as="text",encoding = "UTF-8")

#CONVERTING THE ABOVE OBJECT INTO JSON ARRAY 
# %>% IS USED FOR PIPELINING TWO FUNCTIONS
json_content <-content %>% fromJSON


#REMOVING DOUBLE QUOTES FROM THE STRING
remove_double_quotes <- function(str)
{
  str <- gsub('"',' ',str)
  return(str)
}

#REMOVING SINGLE QUOTES FROM THE STRING
remove_single_quotes <- function(str)
{
  str <- gsub("'"," ",str)
  return(str)
}

#Storing it in variables for forming a query
id <- json_content$id

first_name <- json_content$first_name
first_name <- remove_double_quotes(first_name)
first_name <- remove_single_quotes(first_name)

last_name <- json_content$last_name
last_name <- remove_double_quotes(last_name)
last_name <- remove_single_quotes(last_name)

gender <- json_content$gender

email <-json_content $email

location <-json_content$location$name

#Forming a SQL Insert Query
query <- "INSERT INTO USER_DETAILS VALUES("
final_query <-paste(query,id,",'",first_name,"'",",'",last_name,"'",",'",gender,"'",",'",email,"'",",'",location,"')")
final_query
#Storing it in DB!
dbSendQuery(mydb,final_query)





