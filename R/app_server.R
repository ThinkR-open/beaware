#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # Your application server logic

  global <- reactiveValues(x = 0)

  observeEvent(input$onglet,{
    global$onglet <- input$onglet
  })

  ### Reactive of app

  invalide <- reactiveTimer(3000)

  observeEvent(invalide(),{
    global$info_all <- get_all_info()
    global$get_memory <- get_mem_info()
    global$get_memory_user <- get_mem_info_by_user(global$get_memory$memtotal)

    # for test
    global$x <- global$x + 1
  })

  mod_global_server("global_info", global)

  mod_user_server("user_ui_1", global)


  # observeEvent(input$launch,{
  #
  #
  # })

  observeEvent(input$close,{
    stopApp()
  })
}
