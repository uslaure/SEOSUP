
# -*- coding: utf-8 -*-
#' @encoding UTF-8
#'
#' @title SEO
#' @description serp tracker get search engine results page on google.
#' @docType package
#' @name SEO
#' @examples
#'
#' library(SEO)
#' library(dplyr)
#' word_list <- c("big data R","big data","formateur R","apprendre R","installer R",
#' "deep learning R","formateur logiciel R","meetup R","expert R","formation R",
#' "formation logiciel R","vincent guyader","guyader","diane beldame")
#' word_list <- c("big data R","big data","formateur R","apprendre R","installer R",
#' "deep learning R","formateur logiciel R")
#' #daily_run(site_url = "www.thinkr.fr",word_list = word_list,validite =  60*60*24,max=29,timer=2)
#' #daily_run(site_url = "www.allstat.fr",word_list = word_list,validite = 60*60*24,max=29,timer=2)
#' SEO::get_date_position(site_url = "www.thinkr.fr")
#' SEO::plot_evolution_mot(site_url = "www.thinkr.fr",word = "big data")
#' SEO::plot_evolution_mot(site_url = "www.thinkr.fr",word = "big data R")
#' SEO::get_all_position(site_url = "www.thinkr.fr",word_list=  word_list)
#' SEO::get_all_position(site_url = "www.thinkr.fr",word_list=  word_list[1])
#' SEO::get_best_position(site_url = "www.thinkr.fr",word=   "big data R")
#' plot_evolution_mot(site_url = "www.thinkr.fr",word_list=  word_list[1])
#' plot_evolution_mot(site_url = "www.thinkr.fr",word_list=  word_list)
#' compare_position(site_url = "www.thinkr.fr")
#' compare_position(site_url = "www.thinkr.fr",shiny = FALSE)
#' list_url_base()
#' SEO::generate_serp() # full random
#' SEO::get_concurence(site_url = "www.thinkr.fr","formation R") # si le cache est vide on ne va pas chercher l'info
#' SEO::get_concurence(site_url = "www.thinkr.fr","MOT INEDIT") # si le cache est vide on ne va pas chercher l'info
#' #SEO::get_concurence(site_url = "www.thinkr.fr","formation R",cache_only = FALSE) # si le cache est vide on va chercher l'info
#' #SEO::extract_serp("concombre")
#' SEO::generate_serp() %>% plot_serpbourin() # des idées de graph
#'
#' #SEO::shinyseo()
#'
#'
#'
#'
#'
NULL
