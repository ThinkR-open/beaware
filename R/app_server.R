#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {

  # Your application server logic
  local <- reactiveValues()
  global <- reactiveValues(x = 0)

  observeEvent(input$onglet,{
    global$onglet <- input$onglet
  })

  ### Reactive of app

  # invalide <- reactiveTimer(4000)

  observeEvent(input$refresh | global$init,{

    global$info_all <- get_all_info()
    global$get_memory <- get_mem_info()
    global$get_memory_user <- get_mem_info_by_user(global$get_memory$memtotal)

    # for test
    localinfo_all <- global$info_all
    global$refresh <- input$refresh

    if(!identical(local$info_all, local$old_data)){
      global$invalide <- rnorm(1, 0, 10000)
      local$old_data <- local$info_all
    }

  })

  mod_global_server("global_info", global)

  mod_user_server("user_ui_1", global)

  observeEvent(input$close,{
    stopApp()
  })
}
