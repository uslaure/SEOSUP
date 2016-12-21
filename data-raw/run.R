library(SEO)
word_list <- c("big data R","big data","formateur R","apprendre R","installer R",
               "deep learning R","formateur logiciel R","meetup R","expert R","formation R",
               "formation logiciel R","vincent guyader","guyader","diane beldame")
word_list <- c("big data R","big data","formateur R","apprendre R","installer R",
               "deep learning R","formateur logiciel R")
daily_run(site_url = "www.allstat.fr",word_list = word_list,validite = 60*60*24,max=29,timer=2)
daily_run(site_url = "www.thinkr.fr",word_list = word_list,validite =  60*60*24,max=29,timer=2)
word_list <- c("Dessin de voilier",
  "architecte naval","vincent lebailly","conception bateau",
  "design naval","yacht design",
  "architecture navale","plan de bateaux","Designer naval","Ingénieur naval","conception de bateaux","conception de bateau")


daily_run(site_url = "www.vincentlebailly.fr",word_list = word_list,validite = 60*60*24,max=100,timer=2)
SEO::get_date_position(site_url = "www.vincentlebailly.fr")
SEO::get_best_position(site_url = "www.vincentlebailly.fr",word = "design naval")

SEO::get_date_position(site_url = "www.thinkr.fr")
SEO::plot_evolution_mot(site_url = "www.thinkr.fr",word = "big data")
SEO::plot_evolution_mot(site_url = "www.thinkr.fr",word = "big data R")
SEO::get_all_position(site_url = "www.thinkr.fr",word_list=  word_list)
SEO::get_all_position(site_url = "www.thinkr.fr",word_list=  word_list[1])
plot_evolution_mot(site_url = "www.thinkr.fr",word_list=  word_list[1])
plot_evolution_mot(site_url = "www.thinkr.fr",word_list=  word_list)
compare_position(site_url = "www.thinkr.fr")
compare_position(site_url = "www.thinkr.fr",shiny = FALSE)
list_url_base()
SEO::shinyseo()



