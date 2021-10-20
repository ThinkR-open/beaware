#' user UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @importFrom DT DTOutput renderDT
mod_user_ui <- function(id){
  ns <- NS(id)
  tagList(
    # wellPanel(
    selectInput(inputId = ns("users"), label = "Choisir un user", choices = NULL),
    selectInput(inputId = ns("r_version"), label = "Choisir une version de R", choices = NULL),
    fluidRow(
      column(6,
             textOutput(ns("sessions_nb"))
      )
    ),
    fluidRow(
      column(6,
             h3("Memory info"),
             plotOutput(
               ns("ram_session")
             )
      ),
      column(6,
             h3("CPU info"),
             plotOutput(
               ns("cpu_session")
             )
      )
    ),
    hr(),
    br(),
    downloadButton(
      ns("download"),
      label = "Download infos",
      class = "btn-primary"
    ), #%>%
      # tagAppendAttributes(class = "btn-primary"),
    br(),
    br(),
    tableOutput(
      ns("sessions_details")
    )
    # )
  )
}

#' user Server Functions
#'
#' @importFrom dplyr pull filter count select
#' @importFrom stats rnorm
#' @importFrom readr write_csv
#'
#' @noRd
mod_user_server <- function(id, global){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    local <- reactiveValues(flag = TRUE)


    # Update Select input
    observeEvent(global$onglet,{

      if(global$onglet == "Users"){
        message("init update")
        if(local$flag){
          showNotification(
            p("Calculating..."),
            type = "message",
            id = ns("notif"),
            duration = 15
          )
          local$flag <- FALSE
        }
        updateSelectInput(session,
                          inputId = "users",
                          choices = get_all_users())

        local$r_version <- color_and_r_version()$r_version
        local$color_r_version <- color_and_r_version()$color
        names(local$color_r_version) <- local$r_version

        updateSelectInput(session,
                          inputId = "r_version",
                          choices = c("All", local$r_version)
        )
      }


    }, ignoreInit = TRUE, once = TRUE)

    # invalidate to fin new R process
    observeEvent(global$info_all,{

      if(global$onglet == "Users"){
        local$info_all <- global$info_all %>%
          select(pid, name, username, status, r_version, `%cpu`, `%mem`)

        if(!identical(local$info_all, local$old_data)){
          local$invalide <- rnorm(1, 0, 10000)
          local$old_data <- local$info_all
        }
      }

    })

    observeEvent(c(input$users, input$r_version, local$invalide),{

      req(local$info_all)

      local$info_user <- local$info_all %>%
        filter(username == input$users)


      if(input$r_version == "All"){
        local$info_r_version <- local$info_user
      }else{
        local$info_r_version <- local$info_user %>%
          filter(r_version == input$r_version)
      }

    }, priority = -1)


    output$sessions_nb <- renderText({
      req(local$info_r_version)
      paste0("Nombre de sessions : ", nrow(local$info_r_version))
    })

    output$ram_session <- renderPlot({
      req(local$info_r_version)
      removeNotification(ns("notif"))
      validate(need(!is.null(local$info_r_version), "Can't get infos, please check logs."))
      local$info_r_version %>%
        graph_mem(local$color_r_version)
    })

    output$cpu_session <- renderPlot({
      req(local$info_r_version)
      validate(need(!is.null(local$info_r_version), "Can't get infos, please check logs."))
      local$info_r_version %>%
        graph_cpu(local$color_r_version)
    })

    ## download details

    output$download <- downloadHandler(
      filename = function() {
        paste("data-cpu-mem", Sys.Date(), ".csv", sep="")
      },
      content = function(file) {
        write_csv(local$info_all, file)
      }
    )

    output$sessions_details <- renderTable({
      req(local$info_r_version)
      local$info_r_version
    }, options = list(dom = 'bf'))

  })
}

## To be copied in the UI
# mod_user_ui("user_ui_1")

## To be copied in the server
# mod_user_server("user_ui_1")
