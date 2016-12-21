my_db
my_db <- src_sqlite(bdd, create = TRUE)
conv <- c("bananapro"="banana.pro", "guyaderpro"="guyader.pro", "wwwallstatfr"="www.allstat.fr", "wwwguyaderfr"="www.guyader.fr",
  "wwwguyaderpro"="www.guyader.pro", "wwwguyaqsdqsdqsdderpro"="www.guyaqsdqsdqsdder.pro", "wwwritmefr"="www.ritme.fr", "wwwthinkrfr"="www.thinkr.fr"
)

copy_to(my_db, labdd, NEW, temporary = FALSE)

for ( amigrer in dbListTables(my_db$con) %>% grep(pattern="_",value=TRUE,invert=TRUE)){
  labdd <- tbl(my_db, sql(paste("SELECT * FROM", amigrer,""))) %>% collect() %>% as.data.frame()
  NEW <- gsub("\\.","_",conv[amigrer]) %>% setNames(NULL)
  try(dbRemoveTable(my_db$con, NEW))
  try(copy_to(my_db, labdd, NEW, temporary = FALSE))


  ## S4 method for signature 'SQLiteConnection,character'
  dbRemoveTable(my_db$con, amigrer)

}

my_db
c("banana_pro", "guyader_pro", "sqlite_stat1",
  "www_guyader_fr", "www_guyaqsdqsdqsdder_pro") ->trm
for (k in trm){
  dbRemoveTable(my_db$con, k)

}

bdd=file.path(find.package("SEO"), "mabase.sqlite")
my_db <- src_sqlite(bdd, create = TRUE)
word_list <- c("vincent guyader","ritme","big data R","big data","formation R","formation logiciel R",
               "formateur R","apprendre R"," installer R","deep learning R","meetup R","expert R","diane beldame")

for ( B in gsub("\\.","_",paste("words__",list_url_base(),sep=""))){



labdd <- tbl(my_db, sql(paste("SELECT * FROM", B,""))) %>% collect() %>% as.data.frame()
data.frame(word=word_list)
dbRemoveTable(my_db$con, B)
try(copy_to(my_db, data.frame(word=word_list), B, temporary = FALSE))
}

for (aef in c('words__www_guyader_pro','config__www_guyader_pro','www_guyader_pro')){

  dbRemoveTable(my_db$con, aef)
}
