library(openxlsx)
library(dplyr)
library(tidyverse)
library(ggplot2)


path <- "./2019/tabelas_por_mes/tabelas.xlsx"

list <- path %>% 
        excel_sheets() %>% 
        set_names() %>% 
        map(read_excel, path = path)

contasDF2019 <- bind_rows(list)

contasDF2019$CENTRO.DE.CUSTO <- as.factor(contasDF2019$CENTRO.DE.CUSTO)
contasDF2019$RUBRICA <- as.factor(contasDF2019$RUBRICA)


ggplot(contasDF2019, aes(DATA.MOV., IMPORTÂNCIA)) + 
        geom_line() + 
        facet_wrap(.~CENTRO.DE.CUSTO, nrow = 3, ncol = 3)

ggplot(contasDF2019, aes(DATA.MOV., SALDO.CONTABILÍSTICO)) + 
        geom_line() + 
        facet_wrap(.~CENTRO.DE.CUSTO, nrow = 3, ncol = 3)

ggplot(contasDF2019, aes(DATA.MOV., IMPORTÂNCIA)) + 
        geom_point() + 
        facet_wrap(.~RUBRICA, nrow = 3, ncol = 9)

ggplot(contasDF2019, aes(DATA.MOV., SALDO.CONTABILÍSTICO)) + 
        geom_point() + 
        facet_wrap(.~RUBRICA, nrow = 3, ncol = 9)

## Exemplos de cálculos - podem ser automatizados com um group e depois um summarise para uma tabela à parte

## Quanto se gastou em "Comunicações"
sum((filter(contasDF2019, RUBRICA == "COMUNICAÇÕES"))$IMPORTÂNCIA)

## Quanto se gastou em "Comunicações"
sum((filter(contasDF2019, RUBRICA == "ALIMENTAÇÃO"))$IMPORTÂNCIA)

## Quanto se gastou em electricidade
sum((filter(contasDF2019, RUBRICA == "CONSUMO ELECTRICIDADE"))$IMPORTÂNCIA)

## SMAS
sum((filter(contasDF2019, RUBRICA == "CONSUMO ÁGUA (SMAS)"))$IMPORTÂNCIA)






