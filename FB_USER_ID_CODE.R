library(httr)
library(jsonlite)
library(magrittr)
load("fb_oauth_manual")

#SAVING ME FILE FOR FETCHING FROM FB GET QUERY
fb_user_id <- "me"
save(fb_user_id,file="FB_ID_FILE")




#SAVING USER DETAILS FOR SELECTING TABLES OF LIKES,POSTS....
q1 <- "https://graph.facebook.com/v2.12/me?fields=id%2Cname&access_token="
final_query <-paste(q1,fb_oauth_manual,sep ="")
id <- GET(final_query) %>% stop_for_status()
fb_user_id_fetch <- parse_content(id)
fb_user_id_fetch <- fb_user_id_fetch$id
save(fb_user_id_fetch,file="user_id_for_fetch")
