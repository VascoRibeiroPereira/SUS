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

Automatização dos campos de Centro de Custo e Rúbricas
======================================================

Centros de custo e rubricas existentes - GUIDELINES
---------------------------------------------------

    ccRubri <- read.delim("./2020/CentrosdeCusto.csv", sep = ";")
    knitr::kable(ccRubri)

<table>
<thead>
<tr class="header">
<th style="text-align: left;">CENTRO.DE.CUSTO</th>
<th style="text-align: left;">RUBRICA</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">BAR</td>
<td style="text-align: left;">COMPRAS</td>
</tr>
<tr class="even">
<td style="text-align: left;">BAR</td>
<td style="text-align: left;">RECEITA</td>
</tr>
<tr class="odd">
<td style="text-align: left;">NOITE DAS CAMÉLIAS</td>
<td style="text-align: left;">SEG. AC. TRABALHO</td>
</tr>
<tr class="even">
<td style="text-align: left;">NOITE DAS CAMÉLIAS</td>
<td style="text-align: left;">IGAC / SPA</td>
</tr>
<tr class="odd">
<td style="text-align: left;">NOITE DAS CAMÉLIAS</td>
<td style="text-align: left;">DONATIVO DE PORTA</td>
</tr>
<tr class="even">
<td style="text-align: left;">NOITE DAS CAMÉLIAS</td>
<td style="text-align: left;">BENGALEIRO</td>
</tr>
<tr class="odd">
<td style="text-align: left;">NOITE DAS CAMÉLIAS</td>
<td style="text-align: left;">APOIO</td>
</tr>
<tr class="even">
<td style="text-align: left;">NOITE DAS CAMÉLIAS</td>
<td style="text-align: left;">OUTROS</td>
</tr>
<tr class="odd">
<td style="text-align: left;">NOITE DAS CAMÉLIAS</td>
<td style="text-align: left;">BANDA</td>
</tr>
<tr class="even">
<td style="text-align: left;">RECEITA ATIVIDADES CONTRATADAS</td>
<td style="text-align: left;">RECEITA ATIVIDADES CONTRATADAS</td>
</tr>
<tr class="odd">
<td style="text-align: left;">RENDA RESTAURANTE</td>
<td style="text-align: left;">RENDA RESTAURANTE</td>
</tr>
<tr class="even">
<td style="text-align: left;">SÓCIOS</td>
<td style="text-align: left;">HOMENAGENS</td>
</tr>
<tr class="odd">
<td style="text-align: left;">SÓCIOS</td>
<td style="text-align: left;">QUOTAS</td>
</tr>
<tr class="even">
<td style="text-align: left;">SÓCIOS</td>
<td style="text-align: left;">DONATIVO</td>
</tr>
<tr class="odd">
<td style="text-align: left;">TEATRO UNIÃO</td>
<td style="text-align: left;">CENÁRIO</td>
</tr>
<tr class="even">
<td style="text-align: left;">TEATRO UNIÃO</td>
<td style="text-align: left;">GUARDA ROUPA</td>
</tr>
<tr class="odd">
<td style="text-align: left;">TEATRO UNIÃO</td>
<td style="text-align: left;">PUBLICIDADE</td>
</tr>
<tr class="even">
<td style="text-align: left;">TEATRO UNIÃO</td>
<td style="text-align: left;">DONATIVO DE PORTA</td>
</tr>
<tr class="odd">
<td style="text-align: left;">TEATRO UNIÃO</td>
<td style="text-align: left;">APOIO</td>
</tr>
<tr class="even">
<td style="text-align: left;">ATIVIDADES DIVERSAS</td>
<td style="text-align: left;">COMPRAS</td>
</tr>
<tr class="odd">
<td style="text-align: left;">ATIVIDADES DIVERSAS</td>
<td style="text-align: left;">RECEITA</td>
</tr>
<tr class="even">
<td style="text-align: left;">ATIVIDADES DIVERSAS</td>
<td style="text-align: left;">APOIO</td>
</tr>
<tr class="odd">
<td style="text-align: left;">ANIVERSÁRIO SUS</td>
<td style="text-align: left;">COMPRAS</td>
</tr>
<tr class="even">
<td style="text-align: left;">ANIVERSÁRIO SUS</td>
<td style="text-align: left;">RECEITA</td>
</tr>
<tr class="odd">
<td style="text-align: left;">ANIVERSÁRIO SUS</td>
<td style="text-align: left;">APOIO</td>
</tr>
</tbody>
</table>

Evolução do gasto/receita e Saldo
=================================

Gráfico da evolução do saldo(vermelho) e dos movimentos (azul), na conta
da SUS.

    library(ggplot2)
    ggplot(contasDF, aes(DATA.MOV., SALDO.CONTABILÍSTICO, IMPORTÂNCIA)) + 
            geom_line(aes(DATA.MOV., SALDO.CONTABILÍSTICO),color = "red") +
            geom_line(aes(DATA.MOV., IMPORTÂNCIA),color = "blue") +
            labs(x = "Data") + 
            labs(y = "Valor em Euros") + 
            labs(title = "Evolução Saldo e Movimentos") + 
            theme(plot.title = element_text(hjust = 0.5))

![](README_files/figure-markdown_strict/gasto%20e%20receita-1.png)
