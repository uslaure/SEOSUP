#' @title get_url
#' @param vec vector to extract
#' @importFrom stringr str_extract_all str_split
#' @importFrom magrittr %>%
#' @export
get_url <- function(vec) {
  out <-
    vec %>%
     str_extract_all("(http|ftp)(.+)") %>%
    str_split("&sa=U")%>% sapply(FUN=function(.).[[1]]) %>%
     setNames(names(vec))

  out[sapply(out,function(.)length(.)==0)]<-NA
  out
}

#' @title get_ndd
#' @param vec vector to parse
#' @importFrom magrittr %>%
#' @importFrom stringr str_extract_all str_locate str_sub
#' @export


get_ndd <- function(vec) {
  a <- str_extract_all(vec, "(http|ftp)(.+)")%>% unlist()

  coupe <- a  %>% str_locate("[a-z]/[^/]") %>% rowMeans()
  a <- a  %>% str_sub(end = coupe)
  names(a) <- names(vec)
  a
}



#' @title extract_serp
#' @param cache_only boolean if TRUE we dont ask google
#' @param timer time in second between each query
#' @param start which google page do we have to parse
#' @param source google's URL
#' @param word word to track
#' @param validite cache validity
#' @importFrom R.cache loadCache saveCache findCache readCacheHeader
#' @importFrom xml2 read_html
#' @importFrom rvest html_nodes html_children html_attr
#' @export
extract_serp <- function(word, start = 0, source = "https://www.google.com",
                         timer = 10,validite=86400,cache_only=FALSE) {

  word <- gsub(" ", "+", word)
  key <- list(word, start, source)
  out <- loadCache(key)
  if (!is.null(out)) {
    age<-Inf
    try(age<-as.numeric(difftime(Sys.time(),as.POSIXct(readCacheHeader(findCache(key=key))$timestamp),units = "secs")),silent=FALSE)
    if (age < validite | cache_only){return(out)}else{
      message("cache expired")
    }
  }

  if ( cache_only ) {

    out <- rep("VOID",10)
    return(out)
  }


  url <- paste0(source, "/search?client=ubuntu&channel=fs&q=", word,
                "&start=", start, "&pws=0")
  url
  # print(url)

  # on recupere le timer
  temps_dernier <- loadCache(list("timer"))
  if (!is.null(temps_dernier)){
    delai <- round(as.numeric(difftime(Sys.time(), temps_dernier, units = "secs")))}else{
      delai <- Inf

    }
  if (delai < timer) {
    message("we will wait ", timer - delai, " seconds before harassing google")
    Sys.sleep(timer - delai)

  } else {
    message("delai ok ", delai, " secs")

  }

  # message('essai')
  message(url)
  ll<-NULL
  try(ll <- read_html(url))
  if(is.null(ll)){
    message("too much query... please try again later or change IP")
    saveCache(Sys.time(), key = list("timer"))  # on sauvegarde l'horaire derniere requette google
    return(NULL)

  }
  # message("done")
  saveCache(Sys.time(), key = list("timer"))  # on sauvegarde l'horaire derniere requette google
  # ll %>% html_nodes(".r")
  out <-    ll %>% html_nodes(" .r")  %>% html_children() %>% html_attr("href") %>%
    na.omit() %>% as.vector() %>% unique()
 # impossible de scraper .srg directement, je ne sai spas comment afficher ll comme R le voit à ce niveau
 out


  # vire ce qui commence par /search? ou plutot on garde que ce qui commence par url
 out <- out %>% grep("^/url?",.,value = TRUE)
  if (length(out)!=10){ message("il n y a pas 10 resultats sur cette page, cela pourrait poser probleme")}


  if (length(out) != 0) {
    names(out) <- (start + 1):(start + length(out))
  }
  saveCache(out, key = key, comment = "extract_serp")
  out  # SI OUT VIDE PEUT ETRE CACHER TOUS CEUX AU DESSUS
}

#' @title escargot
#' @description generate optiml page order search
#' @param start google page number to start with
#' @param max maximum position to scan
#' @export

escargot <- function(start, max) {


  # start page ou l'on doit commencer a chercher'
  # max page au dela de laquelle il faut pas aller
  # si start est avant max
  cycle <-   c(start + c(0, rep(1:(1 * 100), each = 2) * c(-1, 1)))

  # cycle <- c(start + c(0, rep(1:(1 * ceiling(max/10)), each = 2) * c(-1, 1)))
  # cycle[cycle >= 0 ]
  cycle[cycle >= 0 & cycle <= floor((max-1)/10)] #floor ou ceiling ?






  }



#' @title get_position
#' @description find the position url for a keyword
#' @param site_url url website to find
#' @param word query to search in googl
#' @param max maximum position to scan
#' @param history last known position in google
#' @param timer time in second between each query
#' @param validite cache validity
#' @param source google's url
#' @importFrom magrittr extract
#' @export

get_position <- function(site_url, word, max = 29, history = 0, timer = 10,validite=24*60*60,source= "https://www.google.com") {

  if ( history==1000 | history <1){ history<-1}
  if (history> max){history<- max}
  point_depart <- floor((history-1)/10) # la page de depart pour commencer a tester
  cycle <- escargot(start = point_depart, max = max)



  for (pos in cycle) {
    # print(pos)
    # word %>% extract_serp(start = pos * 10, timer = timer) %>% get_ndd()
    tmp <- word %>%
      extract_serp(start = pos * 10, timer = timer,validite=validite,source=source) %>%
      get_ndd()
    if ((tmp %>% length()) == 0) {
      break
    }

    res <- tmp %>% grepl(site_url, .) %>% sum()
    if (res > 0) {
      break
    }
  }
  out <- tmp %>% extract(tmp %>% grepl(site_url, .)) %>% names() %>%
    extract(1)
  if (length(out) == 0) {
    out <- NA
    return(out)
  }
  try(out[is.na(out)] <- Inf, silent = TRUE)  # moui, mais si ca vaut deja NA , faudrait laisser NA non ?

  out
}



