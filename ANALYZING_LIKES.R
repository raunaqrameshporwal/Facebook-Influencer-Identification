#SCRIPT TO ANALYZE LIKES AND DRAW A BAR CHART,Graph pie chart with the same
library(Rfacebook)
library(RMySQL)


load("my_db_connection")
load("FB_ID_FILE")
load("fb_oauth_auto")
load("fb_oauth_manual")
load("user_id_for_fetch")
options(stringsAsFactors = FALSE)


#forming a query for table
outer_query <- "SELECT COUNT(CATEGORY) FROM "
outer_query <- paste(outer_query,fb_user_id_fetch,"_likes ","WHERE CATEGORY ",sep = "")
#outer query as of now
# "SELECT COUNT(CATEGORY) FROM 10202515709761152_likes WHERE CATEGORY "

#FORMING QUERIES FOR RESPECTIVE CATEGORIES

#1.Company, Organization or Institution (VARIABLE NAEM coi)

#These include Aerospace Company, Agriculture Company, Automotive Company, 
#Biotechnology Company, Cargo & Freight Company, Cause, Chemical Company, 
#College & University, Community Organization, Community Services, Company, 
#Computer Company, Consulting Agency, Education, Elementary School, Energy Company, 
#Finance Company, Food & Beverage Company, Government Organization, Health/Beauty, 
#High School, Industrial Company, Insurance Company, Internet Company, Labor Union,
#Legal Company, Media/News Company, Medical Company, Middle School, Mining Company,
#Non-Governmental Organization, Non-Profit Organization, Organization, 
#Political Organization, Political Party, Preschool, Religious Organization, 
#Retail Company, School, Science, Technology & Engineering, Telecommunication Company, 
#Tobacco Company, and Travel Company.

query <- "like '%cause%' OR category like '%company%' OR category like '%school%' OR category like '%institution%' OR category like '%political%';"
query <-paste(outer_query,query,sep ="")
coi <-dbSendQuery(mydb,query)

#THE RESULT OF ABOVE QUERY REMAINS IN MYSQL SERVER
#TO FETCH IT FURTHER WE USE FETCH N=-1 REPRESENTS FETCH ALL PENDING
coi <- fetch(coi, n=-1)
#CONVERTING COI FROM DATA FRAME TO NUMERIC CLASS
coi <- as.numeric(coi[1])

#2.Artist, Band or Public Figure (VARIABLE NAME abp)

#These include Actor, Artist, Author, Band, Blogger, Chef, Coach, Comedian, Dancer, 
#Entrepreneur, Fashion Model, Fictional Character, Film Director, Fitness Model, 
#Government Official, Journalist, Motivational Speaker, Movie Character, Musician, 
#News Personality, Pet, Photographer, Political Candidate, Politician, Producer, Public Figure, 
#Scientist, Teacher, Video Creator, and Writer.

query <- "like '%actor%' OR category like '%public%' OR category like '%musician%' OR category like '%band%' OR category like '%model%' OR category like '%official%' OR category like '%fashion%' OR category like '%dancer%' OR category like '%chef%' OR category like '%journalist%';"
query <- paste(outer_query,query,sep = "")
abp <- dbSendQuery(mydb,query)

abp <- fetch(abp,n=-1)
abp <- as.numeric(abp[1])

#3.SPORTS (VARIABLE NAME sports)
#THESE INCLUDES SPORTS PERSON/TEAM,SPORTS RELATED
#LIKE STADIUMS,COURTS ETC

query <- "LIKE '%sport%' OR category LIKE '%athlete%';"
query <- paste(outer_query,query,sep = "")
sports <- dbSendQuery(mydb,query)

sports <- fetch(sports,n=-1)
sports <- as.numeric(sports[1])

#CODE FOR OTHERS (VARIABLE others)
#COUNT TOTAL NO OF ROWS IN CATEGORY
#THEN SUBTRACT THE ADDITION OF ABOVE THREE FROM IT

query <- "SELECT COUNT(category) from "
query <- paste(query,fb_user_id_fetch,"_likes;",sep = "")
others <- dbSendQuery(mydb,query)
others <- fetch(others,n=-1)
others <- as.numeric(others[1])
others <- others -(sports+abp+coi)

#TRYING OUT BAR CHART
H <- c(coi,abp,sports,others)
#fullforms <- c("Company, Organization or Institution","Artist, Band or Public Figure")
M <- c("COI","ABP","Sports","Others")

#String to save file in user location
str <- "C:\\Users\\ASUS\\Documents\\SCI SEM 6\\Photos\\likes.png"
png(filename=str)
barplot(H,names.arg = M,xlab = "CATEGORY OF LIKE",ylab = "APPROXIMATE NO OF LIKES",main="LIKES ANALYSIS")
str2 <- "C:\\xampp\\htdocs\\example\\likes.png"
png(filename=str2)
barplot(H,names.arg = M,xlab = "CATEGORY OF LIKE",ylab = "APPROXIMATE NO OF LIKES",main="LIKES ANALYSIS")
dev.off()
