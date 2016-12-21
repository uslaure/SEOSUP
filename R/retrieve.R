#' @title list_url_base
#' @description list all url in base
#' @param bdd the sqlite database path
#' @importFrom magrittr "%>%"
#' @importFrom dplyr src_sqlite
#' @importFrom DBI dbListTables
#' @export



list_url_base <-function(bdd=file.path(find.package("SEO"), "mabase.sqlite")){
  # bdd <- "../shinyseo/mabase.sqlite"
  bdd %>%
    src_sqlite() %>%
    .$con %>%
    dbListTables() %>% gsub(x=.,"_",".") %>%
    grep(x=.,pattern="^sqlite",value=TRUE,invert=TRUE) %>%
    grep(x=.,pattern="^config..",value=TRUE,invert=TRUE) %>%
    grep(x=.,pattern="^words..",value=TRUE,invert=TRUE)
}


#' @title get_last_position
#' @description retrieve last known position
#' @param site_url url website to find
#' @param word query to search in google
#' @param bdd the sqlite database path
#' @importFrom dplyr src_sqlite tbl copy_to sql filter select collect
#' @importFrom utils head
#' @export

get_last_position <- function(site_url, word,bdd=file.path(find.package("SEO"), "mabase.sqlite")){
  my_db <- src_sqlite(bdd, create = TRUE)
  nom_base <- gsub("\\.", "_", site_url)
  la_base<-NULL
  try(la_base <- tbl(my_db, sql(paste("SELECT * FROM", nom_base,""))),silent=TRUE)
  if(is.null(la_base)){return(0)}

  la_base%>%
    filter(mot==word) %>%
    arrange(desc(date)) %>%
    head(1) %>%
    select(position) %>%
    collect() %>%
    unlist()->out
  if(length(out)==0 || is.na(out)){out<-0}
  out
}

#' @title get_best_position
#' @description retrieve best known position
#' @param site_url url website to find
#' @param word query to search in google
#' @param bdd the sqlite database path
#' @importFrom dplyr src_sqlite tbl copy_to sql filter select collect
#' @importFrom utils head
#' @export
get_best_position <- function(site_url, word,bdd=file.path(find.package("SEO"), "mabase.sqlite")){
  my_db <- src_sqlite(bdd, create = TRUE)
  nom_base <- gsub("\\.", "_", site_url)
  la_base<-NULL
  try(la_base <- tbl(my_db, sql(paste("SELECT * FROM", nom_base,""))),silent=TRUE)
  if(is.null(la_base)){return(0)}

  la_base%>%
    filter(mot==word & !is.na(position)) %>%
    arrange((position))  %>%
    head(1) %>%
    select(position) %>%
    collect() %>%
    unlist()->out
  if(length(out)==0 || is.na(out)){out<-0}
  out
}



#' @title get_date_position
#' @description retrieve known position at date
#' @param site_url url website to find
#' @param bdd the sqlite database path
#' @param ladate the date to retrieve information
#' @import dplyr
#' @export

get_date_position <- function(site_url,ladate=Sys.time(),bdd=file.path(find.package("SEO"), "mabase.sqlite")){

  if (is.character(ladate)){ladate<-as.POSIXct(ladate)}
  my_db <- src_sqlite(bdd, create = TRUE)
  nom_base <- gsub("\\.", "_", site_url)
  la_base<-NULL
  try(la_base <-
        tbl(my_db, sql(paste("SELECT * FROM", nom_base,"")))
      ,silent=TRUE)
  if(is.null(la_base)){return(0)}

  la_base %>% collect %>%
    mutate(date=as.POSIXct(date),
           ecart=abs(difftime(date , ladate,units = "secs")),
           url=site_url
    ) %>% group_by(mot) %>%
    # arrange(ecart)  %>%
    top_n(-1,ecart) %>% ungroup() %>% select(-ecart)

}


#' @title get_all_position
#' @description retrieve all knowned position
#' @param site_url url website
#' @param word_list words to track
#' @param bdd the sqlite database path
#' @importFrom dplyr src_sqlite tbl copy_to sql filter select collect
#' @importFrom utils head
#' @export

get_all_position <- function(site_url, word_list,bdd=file.path(find.package("SEO"), "mabase.sqlite")){
  my_db <- src_sqlite(bdd, create = TRUE)
  nom_base <- gsub("\\.", "_", site_url)
  la_base<-NULL
  try(la_base <- tbl(my_db, sql(paste("SELECT * FROM", nom_base,""))),silent=TRUE)
  if(is.null(la_base)){return(0)}
  if (length(word_list)>1){
    la_base%>%
      filter(mot %in% word_list) %>%
      collect() ->out
  }else{
    la_base%>%
      filter(mot == word_list) %>%
      collect() ->out


  }

  # if(length(out)==0 || is.na(out)){out<-0}
  out
}


#' @title compare_position
#' @description evolution between 2 dates
#' @param site_url url website to find
#' @param bdd the sqlite database path
#' @param to start time
#' @param from end time
#' @param shiny booleen are we in a shiny app
#' @import dplyr
#' @importFrom lubridate hours
#' @export

compare_position <- function(site_url,to=Sys.time(),
         from=to-hours(24),
         bdd=file.path(find.package("SEO"), "mabase.sqlite"),shiny=TRUE){
  # best <- get_best_position()
  maintenant <-  get_date_position(site_url = site_url,ladate = to,bdd=bdd)
  avant <-  get_date_position(site_url = site_url,ladate = from,bdd=bdd)
  names(avant) <- paste0(names(avant),"_avant")
  names(maintenant) <- paste0(names(maintenant),"_maintenant")
  merge(avant,maintenant,by.x="mot_avant",by.y="mot_maintenant",all=TRUE) %>% mutate(temps=difftime(date_maintenant,date_avant,units = "day"),
                                                                                     temps=round(temps,1),
                                                                                     fraicheur = difftime(Sys.time(),date_maintenant,units="day"),
                                                                                     fraicheur = round(fraicheur,1),
                                                                                     variation = position_avant - position_maintenant
  ) %>% rename(mot=mot_avant) %>%
    select(mot,variation,position_maintenant,temps,fraicheur,date_maintenant) %>%
    filter(position_maintenant <500) %>%
    rename(position=position_maintenant,
                                               date=date_maintenant
                                               )%>% mutate(pos="",var="")->out# a varier en prod

  out$best <-   sapply(out$mot,FUN = get_best_position,site_url=site_url)
# save(out,file="AEF.RData")
    # try(out$pos<-out$var<-"")
 out<-  out[,c("mot", "variation","var", "position","pos", "best", "temps", "fraicheur",
         "date")]
  if (!shiny){return(out)}

  out

  # # out$variation <- -3:2
  out$pos <- pimp2(out$position)
  out$var <- pimp(out$variation)
  out
}


#'pimp
#'
#'rajoute smiley au varaition
#'@noRd
pimp <-function(vec){
info <- cut(vec,breaks = c(-Inf,-0.001,0.0001,Inf),labels=c("baisse","stagne","monte"))

  # vec[info=="stagne"]<- "<img src='stable.gif' height=30 width=30, alt='0'>  0"
  #
  # vec[info=="baisse"]<- paste0("<img src='baisse.gif' height=30 width=30 alt=",vec[info=="baisse"],"> ",vec[info=="baisse"])
  # vec[info=="monte"]<- paste0("<img src='monte.gif' height=30 width=30 alt=",vec[info=="monte"],"> ",vec[info=="monte"])

vec[info=="stagne"]<- "<img src='stable.gif' height=30 width=30, alt='='>"
vec[info=="baisse"]<- paste0("<img src='baisse.gif' height=30 width=30 alt='+'> ")
vec[info=="monte"]<- paste0("<img src='monte.gif' height=30 width=30 alt='-'> ")


  vec
}

#'pimp2
#'
#'rajoute smiley au position
#'@noRd
pimp2 <-function(vec){
  vec[!(vec%in% c(1,2,3))]<- ""
  vec[vec%in% c(1,2,3)]<- "<img src='smiley.gif' height=30 width=30>"
  vec
}


#' @title get_concurence
#' @description retrieve all knowned position
#' @param site_url url website
#' @param word word to track
#' @param max maximum position
#' @param history start point
#' @param timer timer
#' @param validite cache validity
#' @param cache_only booleen if TRUE we dont ask google
#' @param cible booleen if TRUE search just around history
#' @importFrom dplyr src_sqlite tbl copy_to sql filter select collect
#' @importFrom utils head
#' @export



get_concurence <- function(site_url, word, max = 2, history = 1, timer = 10,
                           validite=Inf,cache_only=TRUE,cible=FALSE) {



  # message("ici")
  message("concurrence pour ",word)
  # message ("cible -> ",cible)

  if (length(word)==0 || word=="NA"){
    message("on degage")
    return(data.frame())

  }

  if ( history==1000){ history<-0}
  if (history> max){history<- max}
  point_depart <- floor((history-1)/10)
  cycle <- escargot(start = point_depart, max = max)

  # on va supprimer les minimum
  # cycle <- cycle[cycle*10 >= min]
  if (cible) {cycle <- cycle[1]}

  res<-c()
  res_url <- c()
  for (pos in cycle) {
    # print(pos)
    # word %>% extract_serp(start = pos * 10, timer = timer) %>% get_ndd()
    first_url <- word %>% extract_serp(start = pos * 10, timer = timer,validite=validite,cache_only=cache_only)

    if ((first_url %>% length()) == 0) {
      # message("fin de résultat")
      break
    }
    tmp <- first_url %>% get_ndd()
    tmp_url <-      first_url %>% get_url()    %>% url_decode()

res <- c(res,tmp)
res_url <- c(res_url,tmp_url)
  }

out <- data.frame(position=seq_len(length(res))  ,  domaine =res  ,      page=unlist(res_url))


# peut etre imposer position et pas faire un seq_len quand bourinage google fait


# TODO faire URL cliquable
out$domaine <- as.character(out$domaine)
out$domaine[!is.na(out$domaine)] <- paste0("<a href='",  out$domaine[!is.na(out$domaine)], "' target='_blank'>", out$domaine[!is.na(out$domaine)],"</a>")
out$page <- as.character(out$page)
out$page[out$page=="character(0)"]<-" "
out$page[out$page!=" "] <- paste0("<a href='",  out$page[out$page!=" "], "' target='_blank'>", "lien","</a>")
out
}
