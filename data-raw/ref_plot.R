rm(list=ls())
library(SEO)
word_list <- c("big data R","big data","formateur R","apprendre R"," installer R","deep learning R","meetup R","expert R")

SEO::daily_run(site_url = "www.thinkr.fr",word_list,max=30,validite = Inf,timer = 1) ->serp
SEO::daily_run(site_url = "www.guyader.fr",word_list,max=30,validite = 60*60*7,timer = 1) ->serp
SEO::daily_run(site_url = "www.allstat.fr",word_list,max=30,validite = 60*60*7,timer = 1) ->serp


generate_serp() -> serp
plot_serp(serp)[[1]]
