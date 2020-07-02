load("fb_oauth_auto")
load("fb_oauth_manual")
users <- getUsers("me",token=fb_oauth,private_info = TRUE)
users

