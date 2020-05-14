Relatórios de Contas
====================

Tratamento de dados do banco
----------------------------

    ## Carregamento de bibliotecas
    library(dplyr)
    library(lubridate)
    library(stringr)

    ## Extracção dos dados
    dataFiles <- list.files("./2020/extratos", pattern = "csv$", full.names = TRUE)

    contasDF <- tibble()

    for (i in 1:length(dataFiles)){
            contasDF <- contasDF %>% bind_rows(read.delim(dataFiles[i], sep = ";"))
    }

    ## Conversão para formato de data
    tempDateMOV <- dmy(contasDF$DATA.MOV.[1:42])
    tempDateVALOR <- dmy(contasDF$DATA.VALOR[1:42])

    ## Conversão para formato de data (alteração de outra formatação do banco)
    tempDateMOV <- tempDateMOV %>% c(ymd(contasDF$DATA.MOV.[43:(length(contasDF$DATA.MOV.))]))
    tempDateVALOR <- tempDateVALOR %>% c(ymd(contasDF$DATA.VALOR[43:(length(contasDF$DATA.VALOR))]))

    ## Correcção da coluna DATA.MOV. e DARA.VALOR
    contasDF$DATA.MOV. <- tempDateMOV
    contasDF$DATA.VALOR <- tempDateVALOR

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

Evolução do gasto/receita e Saldo
=================================

    library(ggplot2)
    ggplot(contasDF, aes(DATA.MOV., SALDO.CONTABILÍSTICO, IMPORTÂNCIA)) + 
            geom_line(aes(DATA.MOV., SALDO.CONTABILÍSTICO),color = "red") +
            geom_line(aes(DATA.MOV., IMPORTÂNCIA),color = "blue")

![](README_files/figure-markdown_strict/gasto%20e%20receita-1.png)
