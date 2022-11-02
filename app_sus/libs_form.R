## Bibliotecas

library(shiny)
library(DT)
library(shinymanager)
#library(keyring)
library(dplyr)
library(lubridate)
library(stringr)
library(shinyjs)
library(shinydashboard)
library(googlesheets4)
library(ggplot2)
library(plotly)

gs4_deauth()

# Launch database

## define some credentials
# credentials <- data.frame(
#         user = c("sus", "direção", "test"), # mandatory
#         password = c("12345", "12345", "12345"), # mandatory
#         start = c(NA), # optional (all others)
#         expire = c(NA, NA, NA), # input a date like "2022-12-31"
#         admin = c(TRUE, FALSE, FALSE),
#         comment = "Simple and secure authentification mechanism
#   for single ‘Shiny’ applications.",
#         stringsAsFactors = FALSE
# )
# 
# key_set("R-shinymanager-key", "obiwankenobi")
# 
# create_db(
#         credentials_data = credentials,
#         sqlite_path = "database.sqlite", # will be created
#         passphrase = key_get("R-shinymanager-key", "obiwankenobi")
#         #passphrase = "passphrase_wihtout_keyring"
# 
# )


## Tabela de atribuições CC e Rubricas
### Para facilitar a edição do automatismo, este vai buscar a tabela à spreadsheet na google drive da SUS

#CCR <- read.csv("./CentrosdeCusto.csv", sep=";") ## comentado pois se obteve uma solução mais eficiente (google spreadsheet)
CCR <- read_sheet("https://docs.google.com/spreadsheets/d/1lV2z3PpiX3VaskRvJS_l5XpBb2Yf7dYlCX4w8i4NlSM/edit?usp=sharing", col_types = "c")
colnames(CCR) <- c("CENTRO.DE.CUSTO", "RUBRICA")
CC <- unique(CCR$CENTRO.DE.CUSTO)
CCrub <- unique(CCR$RUBRICA)
#auto_cc_r <- read.csv("auto_cc_r.csv") ## comentado pois se obteve uma solução mais eficiente (google spreadsheet)
auto_cc_r <- read_sheet("https://docs.google.com/spreadsheets/d/1dNG9Ey_uLYZER5beAxvl68F4y0rLLHY1ZyMBpPywweY/edit?usp=sharing", col_types = "c")

## Contas - Google Spreadsheet

folhasContas <- sheet_names("https://docs.google.com/spreadsheets/d/1av972Q5o1D2vaS3bCkeGvVecbvfRKjOPizJgJlbIQQk/edit?usp=sharing")

contas <- lapply(folhasContas, function(x) read_sheet("https://docs.google.com/spreadsheets/d/1av972Q5o1D2vaS3bCkeGvVecbvfRKjOPizJgJlbIQQk/edit?usp=sharing", sheet = x))
contas <- do.call(rbind.data.frame, contas)

### Formatação dos dados para apresentar graficamente

Contas_Anual_Receita <- contas %>% filter(IMPORTÂNCIA > 0) %>% group_by(CENTRO.DE.CUSTO, year(DATA.MOV.))
Contas_Anual_Receita <- Contas_Anual_Receita %>% summarise(Valores = sum(IMPORTÂNCIA))

Contas_Anual_Gasto <- contas %>% filter(IMPORTÂNCIA < 0) %>% group_by(CENTRO.DE.CUSTO, year(DATA.MOV.))
Contas_Anual_Gasto <- Contas_Anual_Gasto %>% summarise(Valores = sum(IMPORTÂNCIA))

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