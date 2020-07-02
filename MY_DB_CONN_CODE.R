library(RMySQL)
mydb=dbConnect(MySQL(),user="root",password="root",dbname="sem6"
               ,host="127.0.0.1",port=3307)
save(mydb,file="my_db_connection")
