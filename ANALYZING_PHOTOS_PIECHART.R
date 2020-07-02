#ANALYZING PHOTOS AND SAVING LATEST 5 PHOTOS
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



#FORMING QUERY FOR TOP 7 FRIENDS INCLUDING THE USER
a1 <- "SELECT count(Friend_id) ,Friend_name FROM "
a1 <- paste(a1,fb_user_id_fetch,"_photos ",sep = "")
a1 <- paste(a1,"group by(Friend_id) order by count(Friend_id) DESC",sep = "")

#FORMING QUERY FOR TOTAL NO OF PHOTOS
a2 <- "SELECT count(Friend_id) FROM "
a2 <- paste(a2,fb_user_id_fetch,"_photos",sep = "")


#FETCHING TOP 7 FRIEND IF EXISTS
 r1 <- dbSendQuery(mydb,a1)
 r1 <- fetch(r1,n=-1)

 #VECTOR FOR NAME(name)
 name <- ""
 #VECTOR FOR COUNT(count)
 count <- NULL
 i <- 1
 
 while(i<=nrow(r1)&&i<=7)
 {
   name <- c(name,r1$Friend_name[i])
   count <- c(count,r1$`count(Friend_id)`[i])
   i <- i+1
   }
   
 #TOTAL No of Photos (total_count)
  r2 <- dbSendQuery(mydb,a2)
  total_count <- fetch(r2,n=-1)
  
  #REMOVING FIRST "" IN NAME
  name <- name[-1]
 
  
#PLOTTING PIE CHART
  
#Converting friend count into percentage and rounding off
percent <- round(100*count/sum(count),1)

#plotting the chart
str3 <- "C:\\xampp\\htdocs\\example\\photos.png"
png(filename=str3)
pie(count, labels = percent, main = "PIE CHART OF PHOTOS",col = rainbow(length(count)),radius = 1.0)
legend("top", name, cex = 0.7,fill = rainbow(length(count)))
dev.off()
#FETCHING LAST 5 PHotos

a3 <- "SELECT photo_link FROM "
a3 <- paste(a3,fb_user_id_fetch,"_photos",sep = "")
r3 <- dbSendQuery(mydb,a3)
r3 <- fetch(r3,n=-1)

#Saving it one by one
i<- 1
while(i<=5)
{
  if(r3[i,"photo_link"]!="NA")
  {
  if(i==1)
  {
    download.file(url=r3[i,"photo_link"],destfile = "C:\\xampp\\htdocs\\example\\1.jpg",mode = "wb")
  }
  if(i==2)
  {
    download.file(url=r3[i,"photo_link"],destfile = "C:\\xampp\\htdocs\\example\\2.jpg",mode = "wb")
  }
  if(i==3)
  {
    download.file(url=r3[i,"photo_link"],destfile = "C:\\xampp\\htdocs\\example\\3.jpg",mode = "wb")
  }
  if(i==4)
  {
    download.file(url=r3[i,"photo_link"],destfile = "C:\\xampp\\htdocs\\example\\4.jpg",mode = "wb")
  }
  if(i==5)
  {
    download.file(url=r3[i,"photo_link"],destfile = "C:\\xampp\\htdocs\\example\\5.jpg",mode = "wb")
  }
i <- i+1
  }}

 

