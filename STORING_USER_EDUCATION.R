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

#EDUCATION TABLE IS CREATED WITH THE NAME -> education_details
#IN CASE OF " ' EXTRACT CODE FROM extra_education.r


#FORMING HTTP QUERY
q1 <- "https://graph.facebook.com/v2.12/"
q2 <- "?fields=education%2Cname&access_token="
httpquery <- paste(q1,fb_user_id,q2,fb_oauth_manual,sep = "")

#CALLINT THE API
result <- GET(httpquery) %>% stop_for_status()

#PARSING THE ABOVE API's REPLY
parsed_content <- parse_content(result)
names(parsed_content$education$school$name)
parsed_content$education$school$name[2]
#CONVERTING THE PARSED CONTENT INTO DATA FRAME
#df <- as.data.frame(parsed_content)


#FORMING AN INSERT FUNCTION
insert_education <- function (df)
{

  q1 <- "INSERT INTO education_details VALUES("
  q2 <-paste(q1,df$id,",","'",df$name,"',",sep = "")
  
  i<-1
  while(i<=3)
  {
    
    if(i<3)
    {
    temp <-paste("'",df$education$type[i],"','",df$education$school$name[i],"',",sep = "")
    q2 <- paste(q2,temp,sep = "")
    
    }
    if(i==3)
    {
      temp <-paste("'",df$education$type[i],"','",df$education$school$name[i],"')",sep = "")
      q2 <- paste(q2,temp,sep = "")
    }
    i <-i+1
      
  }
  dbSendQuery(mydb,q2)
}

#Calling the above function
insert_education(parsed_content)

