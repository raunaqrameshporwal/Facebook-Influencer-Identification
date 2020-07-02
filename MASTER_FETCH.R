source("MY_DB_CONN_CODE.R")
source("FB_OAUTH_MANUAL_CODE.R")
source("FETCHING_FUNCTIONS.R")
source("FB_USER_ID_CODE.R")
#Storing
source("STORING_USER_DETAILS.R")
source("STORING_USER_LIKES.R")
source("STORING_USER_FEED.R")
source("STORING_USER_POSTS.R")
source("STORING_USER_EDUCATION.R")
source("STORING_USER_BIRTHDAY.R")
source("StORING_USER_PHOTOS.R")

#Analyzing
source("ANALYZING_LIKES.R")
source("ANALYZING_PHOTOS_PIECHART.R")
source("WORDCLOUD.R")

dbDisconnect(mydb)

#then reinstall install.pacakges("httr")