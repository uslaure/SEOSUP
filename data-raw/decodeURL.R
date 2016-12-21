library(rvest)
library(stringr)
read_html("https://perishablepress.com/url-character-codes/")->kk
kk %>% html_node(".entry-content > ul") %>% html_text() %>% str_split("\n") %>% unlist() %>% strsplit(" ") %>% unlist %>%
  matrix(ncol = 3,byrow=TRUE) %>% .[,c(1,3)] %>% data.frame() -> conv

yo[,c(1,3)]
