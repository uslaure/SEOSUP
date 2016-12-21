#' @title config_to_bdd
#' @description save url config to bdd
#' @param site_url url website to find
#' @param max maximum position to scan
#' @param bdd the sqlite database path
#' @param timer time in second between each query
#' @param validite cache validity
#' @param source google's url
#' @import dplyr
#' @importFrom DBI dbExistsTable dbSendQuery dbRemoveTable
#' @export

config_to_bdd <- function(site_url ,max = 100, timer = 10,validite=24*60*60,
                          bdd=file.path(find.package("SEO"), "mabase.sqlite"),source= "https://www.google.com") {

  my_db <- src_sqlite(bdd, create = TRUE)
  bddtmp_config <- data.frame(max = max, timer = timer, validite = validite,source=source)
  nom_base_config <- paste0("config__",gsub("\\.", "_", site_url))

  # on va effacer la base si elle existe
  if (dbExistsTable(my_db$con,nom_base_config)){
    try(DBI::dbRemoveTable(my_db$con, nom_base_config))
  }
  copy_to(my_db, bddtmp_config, nom_base_config, temporary = FALSE)



}


#' @title word_list_to_bdd
#' @description save url word_list to bdd
#' @param site_url url website to find
#' @param word_list query to search in googl
#' @param bdd the sqlite database path
#' @param append do we have to add word or to replace word_list
#' @import dplyr
#' @importFrom DBI dbExistsTable dbSendQuery dbRemoveTable
#' @export

word_list_to_bdd <- function(site_url ,word_list,
                             bdd=file.path(find.package("SEO"), "mabase.sqlite"),append=FALSE) {


  if (append){

    # ici on recupere les mot pour les rajouter a ceux envoyés

  }

  word_list <- sort(word_list)

  my_db <- src_sqlite(bdd, create = TRUE)
  bddtmp_word_list <- data.frame(word = word_list)
  nom_base_word_list <- paste0("words__",gsub("\\.", "_", site_url))

  # on va effacer la base si elle existe
  if (dbExistsTable(my_db$con,nom_base_word_list)){
    try(DBI::dbRemoveTable(my_db$con, nom_base_word_list))
  }
  copy_to(my_db, bddtmp_word_list, nom_base_word_list, temporary = FALSE)



}





#' @title bdd_to_config
#' @description get  url config from bdd
#' @param site_url url website to find
#' @param bdd the sqlite database path
#' @import dplyr
#' @importFrom DBI dbExistsTable dbSendQuery
#' @importFrom stringr str_trim
#' @export

bdd_to_config <- function(site_url,bdd=file.path(find.package("SEO"), "mabase.sqlite")) {

  my_db <- src_sqlite(bdd, create = TRUE)
  bddtmp_config <- data.frame(max = 20, timer = 3, validite = 60*60*24,source="https://www.google.com")
  nom_base_config <- paste0("config__",gsub("\\.", "_", site_url))

  if (!dbExistsTable(my_db$con,nom_base_config)){
    labdd <- copy_to(my_db, bddtmp_config, nom_base_config, temporary = FALSE)  # need to set temporary to FALSE
  }else{
    labdd <- tbl(my_db, sql(paste("SELECT * FROM", nom_base_config,"")))
  }

  collect(labdd)
}



#' @title bdd_to_word_list
#' @description get  url config from bdd
#' @param site_url url website to find
#' @param bdd the sqlite database path
#' @import dplyr
#' @importFrom DBI dbExistsTable dbSendQuery
#' @importFrom stringr str_trim
#' @export

bdd_to_word_list <- function(site_url,bdd=file.path(find.package("SEO"), "mabase.sqlite")) {

  my_db <- src_sqlite(bdd, create = TRUE)
  bddtmp_word_list <- data.frame(word = "")
  nom_base_word_list <- paste0("words__",gsub("\\.", "_", site_url))

  if (!dbExistsTable(my_db$con,nom_base_word_list)){
    labdd <- copy_to(my_db, bddtmp_word_list, nom_base_word_list, temporary = FALSE)  # need to set temporary to FALSE
  }else{
    labdd <- tbl(my_db, sql(paste("SELECT * FROM", nom_base_word_list,"")))
  }

  out <- collect(labdd)

  nrow(out)
rbind(out,data.frame(word=rep("", max(30-nrow(out),1))))
}
