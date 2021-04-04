## Bibliotecas

library(shiny)
library(DT)
library(shinymanager)
library(keyring)
library(dplyr)
library(lubridate)
library(stringr)
library(shinyjs)
library(shinydashboard)

## Tabela de atribuições CC e Rubricas
CCR <- read.csv("./CentrosdeCusto.csv", sep=";")
CC <- unique(CCR$CENTRO.DE.CUSTO)
CCrub <- unique(CCR$RUBRICA)

auto_cc_r <- read.csv("auto_cc_r.csv")
#d1 = auto_cc_r
#d1$Date = Sys.time() + seq_len(nrow(d1))

## Função de automatismo


mensalFunction <- function(contasDF){
        

        ## Carregar tabela com o automatismo - conjunto de códigos de movimentos bancários associados a cc e rubricas
        #auto_cc_r <- read.csv("auto_cc_r.csv")
        
        ## Conversão para formato de data
        contasDF$DATA.MOV. <- ymd(contasDF$DATA.MOV.)
        contasDF$DATA.VALOR <- ymd(contasDF$DATA.VALOR)
        
        ## Correcção da formatação para valores numericos
        contasDF$IMPORTÂNCIA <- contasDF$IMPORTÂNCIA %>% 
                str_replace_all("[.]", "") %>%
                str_replace_all("[,]", ".") %>%
                as.numeric()
        
        ## Correcção da formatação para valores numericos
        contasDF$SALDO.CONTABILÍSTICO <- contasDF$SALDO.CONTABILÍSTICO %>% 
                str_replace_all("[.]", "") %>%
                str_replace_all("[,]", ".") %>%
                as.numeric()
        
        ## Adicionar as colunas novas e popular com o automatismo
        
        contasDF$CENTRO.DE.CUSTO <-  NA
        contasDF$RUBRICA <-  NA
        
        for (i in 1:nrow(auto_cc_r)) {
                if (sum(grepl(auto_cc_r$scode[i], contasDF$DESCRIÇÃO)) > 0) {
                        contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = ifelse(grepl(auto_cc_r$scode[i], DESCRIÇÃO), auto_cc_r$ccusto[i], CENTRO.DE.CUSTO))
                        contasDF <- mutate(contasDF, RUBRICA = ifelse(grepl(auto_cc_r$scode[i], DESCRIÇÃO), auto_cc_r$rub[i], RUBRICA))
                }
        }
        
        
        # Adição de factor de mês para separar a tabela
        contasDF <- contasDF %>% mutate(Mês = as.factor(month(contasDF$DATA.MOV.)))
        contasDF <- contasDF[, c(8, 1:7)] # colocação do factor na coluna inicial
        
        return(contasDF)
        
}