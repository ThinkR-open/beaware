#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import miniUI
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    fluidPage(
      theme = theme_shiny(),

      div(class = "static-top", gadgetTitleBar(p("Get Infos About Memory", icon("chart-area")),
                     right = miniTitleBarButton("close", "Close", primary = TRUE),
                     left = NULL)),
      actionButton("refresh", label = "Refresh data!", icon = icon("refresh"), class = "btn-primary btn-sm static-top-btn"),
      hr(),
      br(),
      br(),
      br(),
      tabsetPanel(
        id = "onglet",
        type = c("pills"),
        tabPanel(
          "Global", # this name is used in app, becareful when change it
          mod_global_ui("global_info")
        ),
        tabPanel("Users", # this name is used in app, becareful when change it
                   mod_user_ui("user_ui_1")
        )
      )

    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){

  add_resource_path(
    'www', app_sys('app/www')
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'beaware'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}

