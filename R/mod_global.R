#' global UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_global_ui <- function(id){
  ns <- NS(id)
  tagList(
    # wellPanel(
      h3("Information about memory"),
      textOutput(
        ns("ram_total")
      ),
      br(),
      plotOutput(ns("graph_memory"))
    # )

  )
}

#' global Server Functions
#'
#' @noRd
mod_global_server <- function(id, global){
  moduleServer( id, function(input, output, session){
    ns <- session$ns


    output$ram_total <- renderText({

      used <- round(global$get_memory$usedmemory/global$get_memory$memtotal * 100, 2)
      paste0("Total of memory used: ", used, " %")

    })

    output$graph_memory <- renderPlot({
      global$get_memory_user %>%
        graph_mem_all(global$get_memory$memtotal)
    })

  })
}

## To be copied in the UI
# mod_global_ui("global_ui_1")

## To be copied in the server
# mod_global_server("global_ui_1")
