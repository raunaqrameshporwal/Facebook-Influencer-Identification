#EXTRA COE FOR EDUCATION IN CASE OF ' " OR ANY CHARACTER NOT SUPPORTED BY MYSQL

if(!is.null(df$education.school[i,2]))
{
  df$education.school[i,2] <- remove_single_quotes(df$education.school[i,2])
  df$education.school[i,2] <- remove_double_quotes(df$education.school[i,2])
  df$education.school[i,2] <- remove_character_quotes(df$education.school[i,2])
}
else
{
  df$education.school[i,2] <- "NULL"
}

if(!is.null(df$education.type[i]))
{
  df$education.type[i]   <- remove_single_quotes(df$education.type[i])
  df$education.type[i]   <- remove_double_quotes(df$education.type[i])
  df$education.type[i]   <- remove_character_quotes(df$education.type[i])
}
else
{
  df$education.type[i] <- "NULL"
}
