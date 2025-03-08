# Generated by fusen: do not edit by hand

#' Get all info about meme and cpu rsession
#'
#' @return data.frame
#' @export
#'
#' @importFrom dplyr left_join
#'
#' @examples
#' get_all_info()
#' get_all_info()
get_all_info <- function(){
  r_process <- get_process_rsession()
  r_version <- get_r_version(r_process$pid)
  cpu_mem <-  get_mem_cpu()
  
  if(nrow(r_process) == 0){
    message("Don't find process init with rstudio.")
    return("")
  }
  
  r_process %>% 
    left_join(r_version, by = "pid") %>% 
    left_join(cpu_mem, by = "pid") %>% 
    mutate(pid = as.character(pid))
}

