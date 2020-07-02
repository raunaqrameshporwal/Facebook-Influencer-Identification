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

#FUNCTION TO PARSE JSON
parse_content <- function(req)
{
  content <- content(req,as = "text", encoding = "UTF-8")
  if(identical(content,""))warn("NO OUTPUT TO PARSE")
  fromJSON(content)
  
}

#REMOVING DOUBLE QUOTES FROM THE STRING
remove_double_quotes <- function(str)
{
  str <- gsub('"','  ',str)
  return(str)
}

#REMOVING SINGLE QUOTES FROM THE STRING
remove_single_quotes <- function(str)
{
  str <- gsub("'"," ",str)
  return(str)
}

#REMOVING VARIOUS CHARACTERS FROM THE STRING
remove_character_quotes <- function(str)
{
  str <- gsub(";|:|(|)|/","",str)
  return(str)
}
