
# Compile Data ------------------------------------------------------------



#' Compile data from 'raw' SWARM, Qualtrics & Knack CSVs
#'
#' \code{compile_data} Compiles data from 'raw' CSVs exported from the various
#' platforms used (SWARM, Qualtrics, Knack) for the Hunt Challenge 2020,
#' and saves tidied versions of them to the package data file, overwriting any
#' that were already saved.
#'
#' Use this function to refresh the tidied versions of the data whenever the
#' raw data is updated.
#'
#' @export
#' 
#' @examples
#' \dontrun{
#' # (re-)compile data
#' compile_data()
#' }
generate_documentation = function(path = "data/") {
    
    require(data.table)
    
    
    
    # Save compiled data to package, tidy environment, and reload the package.
    save(repo,
         file="huntr/data/repo.RData")
    remove(repo)
    message("Reloading package...")
    devtools::load_all("huntr")
    
}
