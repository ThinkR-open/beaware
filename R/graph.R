#' Graph memory
#'
#' @param data data of result get_all_info
#'
#' @return ggplot
#'
#' @importFrom ggplot2 aes ggplot geom_col scale_y_continuous labs scale_fill_manual
#' @importFrom forcats fct_reorder
#'
#' @name graph
#'
graph_mem <- function(data){
  colors_r <- color_r_version(data)

  data %>%
  ggplot() +
    aes(x = fct_reorder(pid, -`%mem`), y = `%mem`, fill = r_version) +
    geom_col() +
    scale_y_continuous(limits = c(0,100)) +
    labs(x = "process id",
         y= "% of memory") +
    scale_fill_manual(values = colors_r)
}

#' @rdname graph
graph_cpu <- function(data){
  colors_r <- color_r_version(data)

  data %>%
    ggplot() +
    aes(x = fct_reorder(pid, -`%cpu`), y = `%cpu`, fill = r_version) +
    geom_col() +
    scale_y_continuous(limits = c(0,100)) +
    labs(x = "process id",
         y= "% of memory") +
    scale_fill_manual(values = colors_r)
}
