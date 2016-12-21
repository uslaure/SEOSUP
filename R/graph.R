#' @title plot_serpbourin
#' @description fait des dessins
#' @param serp serp
#' @import dplyr
#' @importFrom reshape2 melt dcast
#' @importFrom xts xts
#' @import ggplot2
#' @importFrom dygraphs dygraph
#' @importFrom zoo autoplot.zoo
#'
#' @export


 plot_serpbourin <-function(serp){
}
   #   @importFrom ggTimeSeries ggplot_calendar_heatmap
#   serp %>% mutate(date=as.POSIXct(date)) %>%
#     as.data.frame()->serp
#   serp[-1,] %>% dcast(date~mot,fun.aggregate = mean,na.rm=TRUE)  ->serp
#   serp[is.na(serp)]<-NA
#   serp[!is.na(serp[,1]),]->serp
#   # serp[,-1][serp[,-1]>100]<-40,fu
#   xts(serp[,-1],order.by = serp[,1]) %>% dygraph() -> out1
#   xts(serp[,-1],order.by = serp[,1]) %>% autoplot  -> out2
#
#   serp %>% melt(id.vars="date",variable.name="mot") %>%
#     mutate(ann=format(date,"%Y")) %>%
#
#     ggplot_calendar_heatmap(
#       .,
#       'date',
#       'value'
#     )+
#     xlab('') +
#     ylab('') +
#     scale_fill_continuous(low = 'green', high = 'red') +
#     facet_wrap(c('mot','ann'), ncol = serp$date %>% format("%Y") %>% unique() %>% length())->out3
#   list(out3,out2,out1)
# }




#' @title plot_evolution_mot
#' @description draw evolution of an url position for one word
#' @param site_url the site url
#' @param word_list the list of words
#' @param bdd the sqlite database path
#' @importFrom magrittr "%>%"
#' @importFrom xts xts
#' @importFrom dygraphs dygraph dyAxis dyOptions dyLegend
#' @importFrom lubridate ymd_hms now days
#' @importFrom zoo na.locf
#' @export

plot_evolution_mot <-function(site_url,word_list,bdd=file.path(find.package("SEO"), "mabase.sqlite")){
  # save(site_url,word_list,file="AEFFF.Rdata")
  dataset <- get_all_position(site_url =site_url,word_list = word_list ,bdd=bdd)
  if (dataset ==0 || nrow(dataset)==0){
    return(dygraph(
      xts(c(NA,NA),order.by =c(now(),now()+1))
      ) %>%   dyAxis(name="y",label = "position",valueRange=c(30,-1)) %>%
      dyOptions(stepPlot = TRUE))

  }

  dataset <-    dataset %>% dcast(...~mot,value.var="position")
  dataset_ts <- xts(dataset[,-1],order.by = ymd_hms(dataset$date))
  names(dataset_ts) <- names(dataset)[-1]

  # on peut appliquer un remplissage des NA
  dataset_ts <- zoo::na.locf(dataset_ts)

  dygraph(dataset_ts) %>%   dyAxis(name="y",label = "position",valueRange=c(30,-1)) %>%
    dyOptions(stepPlot = TRUE) %>% dyLegend(labelsDiv = "legendDivID",
                                            show="always",
                                            labelsSeparateLines=TRUE)
  # %>%
  #    dyRangeSelector(dateWindow = c(now()-days(7),now()))

}

