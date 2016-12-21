source("R/get_.R")
"formation R" %>% extract_serp() %>% get_ndd()
"formation R" %>% extract_serp(source="https://www.google.fr") %>% get_ndd()
"formation logiciel R" %>% extract_serp(source="https://www.google.fr") %>% get_ndd()
"formation logiciel R" %>% extract_serp() %>% get_ndd()
"formateur logiciel R" %>% extract_serp() %>% get_ndd()
"formateur logiciel R2" %>% extract_serp() %>% get_ndd()
"formateur logiciel R2" %>% extract_serp() -> hop
"formateur logiciel R2" %>% extract_serp(start=10) -> hop2
hop

hop2
"formateur logiciel R4" %>% extract_serp() %>% get_ndd()
"formateur logiciel R4" %>% extract_serp(start=10) %>% get_ndd()
"formateur logiciel R4" %>% extract_serp(start=10) %>% get_url()
"formateur logiciel R4" %>% extract_serp() -> hop
"formateur logiciel R4" %>% extract_serp(start=10) -> hop2



"formateur logiciel R" %>% extract_serp() %>% get_ndd()

hop2 %>% get_ndd()
get_position(site_url = "www.allstat.fr",word = "formation R")
get_position(site_url = "www.thinkr.fr",word = "formation R")
get_position(site_url = "www.thinkr.fr",word = "formateur logiciel R")
get_position(site_url = "www.thinkr.fr",word = "cornemuse",max=30)
get_position(site_url = "www.thinkr.fr",word = "cornemuse2",max=100,timer=0)



word_list <- c("cornemuse","cornemusse2","formateur logiciel R4","formateur logiciel R","formation R","vincent guyader")
site_url <- "www.thinkr.fr"
word <- "formation R"

# il faut stocker un URL et une liste de mot clef
get_last_position("www.thinkr.fr","formation R")
get_last_position("www.thinkr.fr","cornemuse")
get_last_position("www.thinkr.fr","cornemuse2")

daily_run(site_url = "www.thinkr.fr",word_list,max=30,validite = 60*5)
daily_run(site_url = "www.allstat.fr",word_list,max=30)
daily_run(site_url = "guyader.pro",word_list,max=30,timer=0,validite = 60*5)
daily_run(site_url = "banana.pro",word_list,max=50,timer=1,validite = 60*5)

R.cache


R.cache::findCache(key=list("timer"))

saveCache
daily_run(site_url = "www.thinkr.fr",word_list,max=30,validite = 60*60*7) ->toplot

get_date_position(site_url = "www.thinkr.fr")
get_date_position(site_url = "www.thinkr.fr",ladate = "2016-10-18 23:14:51" )



library(dygraphs)
lungDeaths <- cbind(mdeaths, fdeaths)
dygraph(lungDeaths)

indoConc <- Indometh[Indometh$Subject == 1, c("time", "conc")]
dygraph(indoConc)
dygraph(indoConc %>% as.data.frame())
indoConc %>% as.data.frame() %>% class
class(indoConc)
glimpse(indoConc)

daily_run(site_url = "www.thinkr.fr",word_list,max=30,validite = 60*60*7) ->toplot
toplot %>% mutate(date=as.POSIXct(date)) %>% as.data.frame()->toplot

library(reshape2)
toplot[-1,] %>% dcast(date~mot)  ->toplot
toplot[,-1][toplot[,-1]>100]<-40
xts(toplot[,-1],order.by = toplot[,1])%>% dygraph()
dygraph(toplot[,c(1,3)])
