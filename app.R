#
# This is a Shiny web application.
#

library(shiny)
library(scidb)

# Define UI for application
ui <- fluidPage(
  # Application title
  titlePanel("SciDB Shim Authentication Demo"),

  # Sidebar with inputs
  sidebarLayout(
    sidebarPanel(
      h4("SciDB Connection"),
      textInput("protocol", label = "Protocol", value = "https"),
      textInput("host", label = "Host", value = "127.0.0.1"),
      textInput("port", label = "Port", value = "8083"),
      textInput("username", label = "Username", value = ""),
      passwordInput("password", label = "Password", value = ""),
      actionButton("connect", "Connect"),
      a(href = ".", target = "_blank", "New Instance")
    ),

    # Show a log
    mainPanel(verbatimTextOutput("log"))
  ),

  includeScript("www/sessionid.js")
)

# Define server logic
server <- function(input, output, session) {
  output$log <- renderPrint({
    print(paste("connect:", input$connect))

    if (input$connect > 0) {
      protocol <- isolate(input$protocol)
      host <- isolate(input$host)
      port <- isolate(input$port)
      username <- isolate(input$username)
      password <- isolate(input$password)

      print(paste("protocol:", protocol))
      print(paste("host:", host))
      print(paste("port:", port))
      print(paste("username:", username))
      print(paste("password: ", if (password != "") "PASSWORD_PROVIDED" else ""))
      print("scidbconnect...")
      db <- tryCatch(
        scidbconnect(
          protocol = protocol,
          host = host,
          port = port,
          username = username,
          password = password
        ),
        error = function(e) {
          print("error...")
          print(e)
          NULL
        }
      )
      if (!is.null(db)) {
        print(paste("new sessionid:", attr(db, "connection")$session))
        print("ls...")
        print(ls(db))

        session$sendCustomMessage("sessionid", attr(db, "connection")$session)
      }
    }

    print(paste("found sessionid:", input$sessionid))
  })
}


# Run the application
shinyApp(ui = ui, server = server)
