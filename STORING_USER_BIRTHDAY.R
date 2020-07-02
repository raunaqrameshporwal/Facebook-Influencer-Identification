#TABLE IS ALREADY CREATED NAMED user_birthday

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

#FORMMING HTTP QUERY
q1 <- "https://graph.facebook.com/v2.12/"
q2 <- "?fields=birthday%2Crelationship_status%2Cfriends&access_token="
httpquery <- paste(q1,fb_user_id,q2,fb_oauth_manual,sep = "")

#parsing
result <- GET(httpquery) %>% stop_for_status()
parsed_result <- parse_content(result)
names(parsed_result)

#INSERTING INTO DB
query1 <- "INSERT INTO user_birthday VALUES("
query1 <- paste(query1,parsed_result$id,",'",parsed_result$birthday,"',",parsed_result$friends$summary$total_count,",'",parsed_result$relationship_status,"')",sep = "")

dbSendQuery(mydb,query1)
