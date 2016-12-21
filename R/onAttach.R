#' @importFrom utils packageDescription
.onAttach <- function(libname, pkgname) {
    # Runs when attached to search() path such as by library() or require()
    if (interactive()) {


        pdesc <- packageDescription(pkgname)
        packageStartupMessage('')
        packageStartupMessage(pdesc$Package, " ", pdesc$Version, " by Vicnent Guyader")
        packageStartupMessage("->  For help type help('SEO')")
        packageStartupMessage('')
            }
}

# enleve les faux positifs du check
globalVariables(c(".",  "date_avant" ,"date_maintenant", "ecart" ,"fraicheur" ,"mot", "mot_avant", "position",
                  "position_avant", "position_maintenant" ,"temps", "variation" )) # faudra mettre les autres pour que le check ne s'enflamme pas trop a cause des NSE

