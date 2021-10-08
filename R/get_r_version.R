#' Get r version for rsession
#'
#' @param pids vector of pids of rsessions
#'  
#' @return
#' data frame of process rsession
#' @export
#'
#' @importFrom attempt attempt
#' @importFrom stringr str_extract
#' @importFrom purrr map_df
#'
#' @examples
#' pids <- get_process_rsession()
#' get_r_version(pids$pid)
get_r_version <- function(pids){
  
  map_df(pids, function(x){
    
    cmd <- paste0("cat /proc/",x,"/environ")
    
    r_version <- attempt(system(cmd, intern = TRUE), msg = "Cannot run cat of /proc/pid, please check your rights") %>% 
      str_extract(".+/R/(.+\\d.\\d.\\d|\\d.\\d.\\d)") %>% 
      str_extract("\\d.\\d.\\d")
    data.frame("pid" = x, r_version = r_version)
  }) 
}
