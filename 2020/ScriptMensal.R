## Carregamento de bibliotecas
library(dplyr)
library(lubridate)
library(stringr)

## Extracção dos dados total
#dataFiles <- list.files("./2020/extratos", pattern = "csv$", full.names = TRUE)

#contasDF <- read.delim(dataFiles[length(dataFiles)], sep = ";")
#contasDF <- as_tibble(contasDF)

## Extração dos dados mês a mês - Correntemente em uso (03/2020)

contasDF <- read.delim("./extratos/Net24_MovConta_050100010730_20200601_20200630.csv", 
                       sep = ";")

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

## Securitas
if (sum(grepl("00026322892", contasDF$DESCRIÇÃO)) > 0) {
        contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = ifelse(grepl("00026322892", DESCRIÇÃO), "INSTALAÇÕES", "NA"))
        contasDF <- mutate(contasDF, RUBRICA = ifelse(grepl("00026322892", DESCRIÇÃO), "SECURITAS - ALARME", "NA"))
}

#SMAS
if (sum(grepl("96611566046", contasDF$DESCRIÇÃO)) > 0) {
        contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = ifelse(grepl("96611566046", DESCRIÇÃO), "INSTALAÇÕES", CENTRO.DE.CUSTO))
        contasDF <- mutate(contasDF, RUBRICA = ifelse(grepl("96611566046", DESCRIÇÃO), "CONSUMO ÁGUA (SMAS)", RUBRICA))
}

#Imposto de selo e despesas bancárias
if (sum(grepl("I.SELO|COMISSÃO MANUTENÇÃO", contasDF$DESCRIÇÃO)) > 0) {
        contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = 
                                   ifelse(grepl("I.SELO|COMISSÃO MANUTENÇÃO", DESCRIÇÃO), 
                                          "INSTALAÇÕES", CENTRO.DE.CUSTO))
        contasDF <- mutate(contasDF, RUBRICA = 
                                   ifelse(grepl("I.SELO|COMISSÃO MANUTENÇÃO", DESCRIÇÃO), "DESP. BANCÁRIAS", RUBRICA))
}

# VODAFONE
if (sum(grepl("00531446107", contasDF$DESCRIÇÃO)) > 0) {
        contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = 
                                   ifelse(grepl("00531446107", DESCRIÇÃO), 
                                          "INSTALAÇÕES", CENTRO.DE.CUSTO))
        contasDF <- mutate(contasDF, RUBRICA = 
                                   ifelse(grepl("00531446107", DESCRIÇÃO), "COMUNICAÇÕES", RUBRICA))
}

# MAFEP
if (sum(grepl("10367661", contasDF$DESCRIÇÃO)) > 0) {
        contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = 
                                   ifelse(grepl("10367661", DESCRIÇÃO), 
                                          "INSTALAÇÕES", CENTRO.DE.CUSTO))
        contasDF <- mutate(contasDF, RUBRICA = 
                                   ifelse(grepl("10367661", DESCRIÇÃO), "ALUGUER EXTINTORES", RUBRICA))
}


# EDP - CONSUMO ELECTRICIDADE Jesélia e SUS
if (sum(grepl("P05100001520", contasDF$DESCRIÇÃO)) > 0) {
        contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = 
                                   ifelse(grepl("P05100001520", DESCRIÇÃO), 
                                          "INSTALAÇÕES", CENTRO.DE.CUSTO))
        contasDF <- mutate(contasDF, RUBRICA = 
                                   ifelse(grepl("P05100001520", DESCRIÇÃO), "CONSUMO ELECTRICIDADE", RUBRICA))
}

# Seguros
if (sum(grepl("11034", contasDF$DESCRIÇÃO)) > 0) {
        contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = 
                                   ifelse(grepl("11034", DESCRIÇÃO), 
                                          "INSTALAÇÕES", CENTRO.DE.CUSTO))
        contasDF <- mutate(contasDF, RUBRICA = 
                                   ifelse(grepl("11034", DESCRIÇÃO), "SEGUROS", RUBRICA))
}

# Limpezas
if (sum(grepl("PT50000700000032524109823", contasDF$DESCRIÇÃO)) > 0) {
        contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = 
                                   ifelse(grepl("PT50000700000032524109823", DESCRIÇÃO), 
                                          "INSTALAÇÕES", CENTRO.DE.CUSTO))
        contasDF <- mutate(contasDF, RUBRICA = 
                                   ifelse(grepl("PT50000700000032524109823", DESCRIÇÃO), "SERVIÇO DE LIMPEZA", RUBRICA))
}

# Manutenção e Obras Gaspar Fontes
if (sum(grepl("PT50003501810000046033029", contasDF$DESCRIÇÃO)) > 0) {
        contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = 
                                   ifelse(grepl("PT50003501810000046033029", DESCRIÇÃO), 
                                          "INSTALAÇÕES", CENTRO.DE.CUSTO))
        contasDF <- mutate(contasDF, RUBRICA = 
                                   ifelse(grepl("PT50003501810000046033029", DESCRIÇÃO), "MANUTENÇÃO/OBRAS", RUBRICA))
}

# SPA
if (sum(grepl("PT50003300000000812850405", contasDF$DESCRIÇÃO)) > 0) {
        contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = 
                                   ifelse(grepl("PT50003300000000812850405", DESCRIÇÃO), 
                                          "NOITE DAS CAMÉLIAS", CENTRO.DE.CUSTO))
        contasDF <- mutate(contasDF, RUBRICA = 
                                   ifelse(grepl("PT50003300000000812850405", DESCRIÇÃO), "IGAC / SPA", RUBRICA))
}

# Gás
if (sum(grepl("PT50003600509910031520496", contasDF$DESCRIÇÃO)) > 0) {
        contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = 
                                   ifelse(grepl("PT50003600509910031520496", DESCRIÇÃO), 
                                          "INSTALAÇÕES", CENTRO.DE.CUSTO))
        contasDF <- mutate(contasDF, RUBRICA = 
                                   ifelse(grepl("PT50003600509910031520496", DESCRIÇÃO), "GÁS", RUBRICA))
}

# Adição de factor de mês para separar a tabela
contasDF <- contasDF %>% mutate(Mês = as.factor(month(contasDF$DATA.MOV.)))
contasDF <- contasDF[, c(8, 1:7)] # colocação do factor na coluna inicial


library(openxlsx)
write.xlsx(contasDF, file = paste("./tabelas_por_mes/", 
                                  month(month(Sys.time())-1, label = TRUE),".xlsx", sep=""))


# setwd("~/R/SUS/2020")
# source("ScriptMensal.R", echo = TRUE)
