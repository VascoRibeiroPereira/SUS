#library(shiny)
#library(DT)

#library(shinymanager)
#library(keyring)

#library(dplyr)

#CCR <- read.csv("./CentrosdeCusto.csv", sep=";")

#CC <- unique(CCR$CENTRO.DE.CUSTO)
#CCrub <- unique(CCR$RUBRICA)

source("libs_form.R")

# Define UI for application 
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
            
            numericInput("rowsHeader", "Número de Linhas no Cabeçalho", value = 8, min = 0),
            p(""),
            numericInput("nCols", "Número de Colunas", value = 5, min = 1),
            p(""),
            radioButtons("sep", "Separador", choices = c(";", ","), inline = TRUE),
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

# Define server logic 
server <- function(input, output) {
    
    data <- eventReactive(input$gobutton,{
        if(is.null(input$file1)){
            return()
        }

      inFile <- input$file1
      myDF <- read.csv(inFile$datapath, skip = input$rowsHeader, sep = input$sep)[,1:input$nCols]

        
  ## CODE THAT READS AND PERFORMS A TRANSFORMATION TO MY DF - AUTOMATISM
      
      myDF <- mensalFunction(myDF)

        
      for (i in 1:nrow(myDF)) {

        if (is.na(myDF$CENTRO.DE.CUSTO[i]) ) { ## this assumes that a code have run before creating the column
            myDF$CENTRO.DE.CUSTO[i] <- as.character(selectInput(paste0("sel", i), "", choices = CC, width = "100px"))
        }
          
        if (is.na(myDF$RUBRICA[i]) ) { ## this assumes that a code have run before creating the column
            myDF$RUBRICA[i] <- as.character(selectInput(paste0("sel2", i), "", choices = CCrub, width = "100px"))
          
        }
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

    selector_CC <- renderPrint({
        str(sapply(1:nrow(data()), function(i) input[[paste0("sel", i)]]))
    })
    
    selector_R <- renderPrint({
      str(sapply(1:nrow(data()), function(i) input[[paste0("sel2", i)]]))
    })
    
    output$downloadData <- downloadHandler(
    
        filename = function() {
            #paste("test.csv")
          paste0(letters[as.integer(levels(data()$Mês))], "_", 
                month(month(as.integer(levels(data()$Mês))), label = TRUE),".csv")
        },
        content = function(file) {
            
          RUBRICA <- unlist(str_extract_all(selector_R(), "[A-Z-Ç Ã Á É Ó Õ - . ( ) /]+")) %>% trimws()
          RUBRICA <- RUBRICA[2:length(RUBRICA)]
          RUBRICA <- RUBRICA[grep("[A-Z]", RUBRICA)]
            
          tmpVector <- grep("NULL", RUBRICA)
            
          for (i in 1:length(tmpVector)){ ## extract auto value and merge it to the selected vector
            RUBRICA[tmpVector[i]] <- data()$RUBRICA[tmpVector[i]]
          }
            
          
          
          CENTRO.DE.CUSTO <- unlist(str_extract_all(selector_CC(), "[A-Z-Ç Ã Á É Ó Õ - . ( ) /]+")) %>% trimws()
          CENTRO.DE.CUSTO <- CENTRO.DE.CUSTO[2:length(CENTRO.DE.CUSTO)]
          CENTRO.DE.CUSTO <- CENTRO.DE.CUSTO[grep("[A-Z]", CENTRO.DE.CUSTO)]
            
          tmpVector <- grep("NULL", CENTRO.DE.CUSTO)
            
          for (i in 1:length(tmpVector)){ ## extract auto value and merge it to the selected vector
            CENTRO.DE.CUSTO[tmpVector[i]] <- data()$CENTRO.DE.CUSTO[tmpVector[i]]
          }

          finalDF <- bind_cols(data() %>% 
                                 select(-CENTRO.DE.CUSTO,-RUBRICA), 
                               CENTRO.DE.CUSTO = CENTRO.DE.CUSTO,
                               RUBRICA = RUBRICA)
          write.csv(finalDF, file, row.names = FALSE)
        }
    )

}

# Run the application 
shinyApp(ui = ui, server = server)
