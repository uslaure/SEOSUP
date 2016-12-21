
#' @title generate_serp
#' @description genre serp classiques
#' @param from date depart
#' @param to date fin
#' @param six_mots vector of words
#' @import dplyr
#' @importFrom reshape2 melt
#' @importFrom stats diffinv na.omit rnorm runif setNames
#' @export

generate_serp <-function(from=as.Date("2015-05-05"),to=Sys.Date(),six_mots=c("mot 1","autre mot","mot 2","tjrs un mot","mot 1","encore un mot")){
  base <-  seq(from=from,to=to,by=1)
  base<-as.POSIXct(base) # rajout
  A <-  round(runif(n = length(base),min = 1,max = 20))
  B <-  sort(round(runif(n = length(base),min = 1,max = 20)))
  C <-  sort(round(runif(n = length(base),min = 1,max = 20)),decreasing = TRUE)
  D <- abs(round(diffinv(rnorm(base))))
  length(D)<-length(base)
  n <-  length(base) # number of data points
  t <- seq(0,4*pi,, length(base))
  a <- 3
  b <- 2
  c.unif <- runif(n)
  c.norm <- rnorm(n)
  amp <- 2
  F <- round(abs(a*sin(b*t)+c.unif*amp+10) )# uniform error
  E <- round(abs(a*sin(b*t)+c.norm*amp+10) )#

  data.frame(base,A,B,C,D,E,F)%>%
    setNames(c("base",six_mots)) %>%
    melt(id.vars="base") %>% setNames(c("date","mot","position"))


}




#' @title url_decode
#' @description decode url
#' @param url the url
#' @param to output
#' @param from input
#' @importFrom stringr str_replace_all
#' @importFrom stats setNames
#' @export


url_decode <- function(url,to=  c("<", ">", "#", "%", "{", "}", "|", "\\", "^", "~", "[", "]",
                                  "`", ";", "/", "?", ":", "@", "=", "&", "$", "+", "\"", " "
),
from=  c("%3C", "%3E", "%23", "%25", "%7B", "%7D", "%7C", "%5C", "%5E",
         "%7E", "%5B", "%5D", "%60", "%3B", "%2F", "%3F", "%3A", "%40",
         "%3D", "%26", "%24", "%2B", "%22", "%20")){

setNames(stringr::str_replace_all(url,setNames(to,from)),names(url))

}
