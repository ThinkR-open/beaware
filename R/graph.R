

#' Graph memory
#'
#' @param data data of result get_all_info
#' @param colors_r colors for r_versions @seealso color_and_r_version
#'
#' @return ggplot
#'
#' @importFrom ggplot2 aes ggplot geom_col scale_y_continuous labs scale_fill_manual
#' @importFrom forcats fct_reorder
#'
#' @name graph
#'
graph_mem <- function(data, colors_r){
  colors_r <- colors_r[unique(data$r_version)]
  data %>%
  ggplot() +
    aes(x = fct_reorder(pid, -`%mem`), y = `%mem`, fill = r_version) +
    geom_col() +
    scale_y_continuous(limits = c(0,100)) +
    labs(x = "process id",
         y= "% of memory") +
    scale_fill_manual(values = colors_r) +
    ggthemes::theme_fivethirtyeight()
}

#' @rdname graph
graph_cpu <- function(data, colors_r){
  colors_r <- colors_r[unique(data$r_version)]
  data %>%
    ggplot() +
    aes(x = fct_reorder(pid, -`%cpu`), y = `%cpu`, fill = r_version) +
    geom_col() +
    scale_y_continuous(limits = c(0,100)) +
    labs(x = "process id",
         y= "% of memory") +
    scale_fill_manual(values = colors_r) +
    ggthemes::theme_fivethirtyeight()
}


#' Graph usage of memory
#'
#' @param data data from get_mem_info_by_user
#' @param max_mem max of memory
#'
#' @importFrom ggplot2 ggplot aes geom_col geom_label scale_y_continuous labs
#'
#' @return ggplot
#'
graph_mem_all <- function(data, max_mem){
  data %>%
    ggplot() +
    aes(x = fct_reorder(username, -mem), y = mem) +
    geom_col() +
    geom_label(label = paste0(mem, " Go")) +
    scale_y_continuous(limits = c(0,max_mem * 1.05)) +
    labs(x = "User",
         y= "number of memory") +
    ggthemes::theme_fivethirtyeight()
}
