
#' @title daily_run
#' @description find the daily position for a url for a list of keyword
#' @param site_url url website to find
#' @param word_list query to search in googl
#' @param max maximum position to scan
#' @param bdd the sqlite database path
#' @param timer time in second between each query
#' @param validite cache validity
#' @param source google's url
#' @import dplyr
#' @importFrom DBI dbExistsTable dbSendQuery
#' @importFrom stringr str_trim
#' @export

daily_run <- function(site_url, word_list, max = 100, timer = 10,validite=24*60*60,
                      bdd=file.path(find.package("SEO"), "mabase.sqlite"),source= "https://www.google.com") {


  if (length(site_url) == 0 | nchar(site_url)<4) return(NULL) # si url est vide ou trop petite pour etre url , on sort

  word_list <- str_trim(word_list)
  word_list <- gsub(" +"," ",word_list)

  my_db <- src_sqlite(bdd, create = TRUE)
  # si url n'existe pas dans sqlite on fabrique une base vierge
  bddtmp <- data.frame(date = NA_character_, mot = NA_character_, position = NA_integer_)
  nom_base <- gsub("\\.", "_", site_url)
  moment <- Sys.time()
  # moment <- 'coucou'
  if (!dbExistsTable(my_db$con,nom_base)){
    labdd <- copy_to(my_db, bddtmp, nom_base, temporary = FALSE)  # need to set temporary to FALSE
  }else{
    labdd <- tbl(my_db, sql(paste("SELECT * FROM", nom_base,"")))
  }


  # ne pas rajouter de ligne si c'est le cache qui a été utilisé...
  # ou pas, car le cache  peut etre utilisé pour une autre URL
  # trouver une idée pour ca... TODO a FAIRE , pour l'sintant on laisse ca permet de peupleur la BDD
  for (word in word_list) {
    if ( setequal(word_list,NULL)){ break} # si la personne a mis NULL dans word list , on init juste la bdd
    message("on va chercher : ",word)
    pos <- get_position(site_url = site_url, word = word, max = max,validite=validite,
                        timer = timer,history = get_last_position(site_url = site_url, word = word),source=source) %>% as.numeric()
    pos[pos > 1000] <- 1000

    if (is.na(pos)) { pos <- "NULL"    }
    dbSendQuery(my_db$con,
                paste0("INSERT INTO ", nom_base, " VALUES (\"",moment, "\",\"", word, "\",", pos, ")")
    )
  }

  collect(labdd)->labdd



  labdd[nrow(labdd):1,]
}
