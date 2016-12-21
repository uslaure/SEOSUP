library(SEO)
SEO::daily_run(site_url = "www.thinkr.fr",word_list = "cornemuse23",validite = 60*60*24,max=15,timer = 0)
SEO::daily_run(site_url = "www.thinkr.fr",word_list = "cornemuse23",validite = Inf,max=15)
SEO::daily_run(site_url = "www.thinkr.fr",word_list = "cornemuse23",validite = Inf,max=15,timer=0)


SEO::daily_run(site_url = "TEST.fr",word_list = NULL,validite = Inf,max=15,timer=0)

word_list <- c("vincent guyader","ritme","big data R","big data","formateur R","apprendre R"," installer R","deep learning R","meetup R","expert R")
SEO::daily_run(site_url = "www.thinkr.fr",word_list = word_list,validite =  60*60*24,max=30,timer=0)
SEO::daily_run(site_url = "www.allstat.fr",word_list = word_list,validite = 60*60*24,max=30,timer=0)
SEO::daily_run(site_url = "guyader.pro",word_list = word_list,validite = 60*60*24,max=30,timer=3)
SEO::daily_run(site_url = "www.ritme.fr",word_list = word_list,validite = 60*60*24,max=30,timer=3)

SEO::daily_run(site_url = "www.dacta.fr",word_list = word_list,validite = Inf,max=30,timer=0)
unique(SEO::get_date_position(site_url = "www.thinkr.fr")$mot) %>% write.csv2(file="aef.csv")
plot_evolution_mot(site_url = "www.thinkr.fr",word_list = word_list)

rvest::html()

xml2::read_html("http://thinkr.fr")
url <-  "https://www.google.com/search?client=ubuntu&channel=fs&q=big+data+R&start=0&pws=0"
xml2::read_html(url)
library(curl)
xml2::read_html(curl("http://www.guyader.pro", handle = curl::new_handle("useragent" = "Mozilla/5.0")))
xml2::read_html(curl(url, handle = curl::new_handle("useragent" = "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:49.0) Gecko/20100101 Firefox/49.0")))
google2 <- read_html(httr::GET("http://google.com"))
google2 <- read_html("http://www.guyader.pro")
r/curl/jeroen


file.copy(from=file.path(find.package("SEO"), "mabase.sqlite"),to="inst/",overwrite = TRUE)
SEO::shinyseo()
