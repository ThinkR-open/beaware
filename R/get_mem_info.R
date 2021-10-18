#' Get mem info
#'
#' @return data.frame
#' @export
#'
#' @importFrom attempt attempt
#' @importFrom stringr str_split str_trim str_extract
#' @importFrom purrr map imap flatten set_names
#'
#' @examples
#' get_mem_info()
get_mem_info <- function(){
  process <-  attempt(
    system("cat /proc/meminfo", intern = TRUE),
    msg = "Cannot get memory info, please chek your rights"
  )

  ok <- process  %>%
  str_split(":") %>%
  map(str_trim) %>%
  map(~ {
    c(.x[1],
      .x[2] %>%
        str_extract("[:digit:]+")
        )
    }) %>%
  map(~ .x[2] %>% set_names(clean_vec(.x[1]))) %>%
  flatten() %>%
  imap(~ as.numeric(.x) / (1024*1024))


data.frame( usedmemory = ok$memtotal - (ok$memfree + (ok$buffers + ok$cached +ok$sreclaimable - ok$shmem)),
            memtotal = ok$memtotal,
            time = Sys.time())
}


#' get mem info for users
#'
#' @param mem_total  total of memory
#'
#' @return data.frame
#' @export
#'
#' @importFrom dplyr %>% left_join group_by summarise mutate arrange desc
#' @importFrom ps ps
#'
#' @examples
#' get_mem_info_by_user(get_mem_info()$memtotal)
get_mem_info_by_user <- function(mem_total){
  ps() %>%
    left_join(get_mem_cpu(rsession = FALSE), by = "pid") %>%
    group_by(username) %>%
    summarise(mem = sum(`%mem`, na.rm = TRUE),
              cpu = sum(`%cpu`, na.rm = TRUE) ) %>%
    mutate(mem = round((mem /100) * mem_total, 2)) %>%
    filter(mem != 0 & cpu != 0) %>%
    arrange(desc(mem))
}
