#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)

# Define UI for application that draws a histogram
ui <- fluidPage(
    titlePanel("Estudo Financeiro SUS"),
    hr(style="border-color: grey;"),
    sidebarLayout(
        sidebarPanel(
            fileInput("file1", "Upload de um ficheiro CSV",
                      accept = c(
                          "text/csv",
                          "text/comma-separated-values,text/plain",
                          ".csv")
            ),
            
            p("Escolha o número de linhas no cabeçalho do ficheiro (default são 8)"),
            numericInput("rowsHeader", "Número de Linhas no Cabeçalho", value = 8, min = 0),
            p(""),
            p("Escolha o número de colunas a importar (default são 5)"),
            numericInput("nCols", "Número de Colunas", value = 5, min = 1),
            p(""),
            p("Created by"),
            a("Vasco Pereira", href = "https://www.linkedin.com/in/vascoribeirosintra/"),
            p(""),
            actionButton("gobutton","Start"),
            downloadButton("downloadData", "Download"),
        ),
        
        mainPanel(
            tabsetPanel(
                tabPanel("Dados Inseridos", dataTableOutput("contents"), verbatimTextOutput('sel'))
                )
            )
        )
    )

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    data <- eventReactive(input$gobutton,{
        if(is.null(input$file1)){
            return()
        }

        inFile <- input$file1
        myDF <- read.csv(inFile$datapath, skip = input$rowsHeader, sep = ";")[,1:input$nCols]
      
        for (i in 1:nrow(myDF)) {
            myDF$selector_test[i] <- as.character(selectInput(paste0("sel", i), "", choices = c("test1", "test2", "test3"), width = "100px"))
        }
        
        myDF
    })
    
    
    output$contents <- DT::renderDataTable(
        data(), escape = FALSE, selection = 'none', server = FALSE,
        options = list(dom = 't', paging = FALSE, ordering = FALSE),
        callback = JS("table.rows().every(function(i, tab, row) {
        var $this = $(this.node());
        $this.attr('id', this.data()[0]);
        $this.addClass('shiny-input-container');
      });
      Shiny.unbindAll(table.table().node());
      Shiny.bindAll(table.table().node());")
    )

    selector_test <- renderPrint({
        str(sapply(1:nrow(data()), function(i) input[[paste0("sel", i)]]))
    })
    
    
    output$downloadData <- downloadHandler(
    
        filename = function() {
            paste("test.csv")
        },
        content = function(file) {

            mySelector <- unlist(strsplit(selector_test(), " "))
            mySelector <- as.character(mySelector[4:length(mySelector)])
            cbind(data(), mySelector)
            write.csv(cbind(data()[,-length(data())], mySelector), file, row.names = FALSE)
            
            
        }
    )

}

# Run the application 
shinyApp(ui = ui, server = server)
