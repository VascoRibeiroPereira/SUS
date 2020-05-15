Tratamento de dados do banco
============================

    ## Carregamento de bibliotecas
    library(dplyr)
    library(lubridate)
    library(stringr)

    ## Extracção dos dados
    contasDF <- read.delim("./extratos/complete2019.csv", sep = ";")
    contasDF <- as_tibble(contasDF)


    ## Conversão para formato de data
    contasDF$DATA.MOV. <- ymd(contasDF$DATA.MOV.)
    contasDF$DATA.VALOR <- ymd(contasDF$DATA.VALOR)

    ## Conversão da descrição para character

    contasDF$DESCRIÇÃO <- as.character(contasDF$DESCRIÇÃO)

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

Rotinas de CC e Rubricas frequentes
===================================

    ## Securitas
    if (sum(grepl("00026322892", contasDF$DESCRIÇÃO)) > 0) {
            contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = ifelse(grepl("00026322892", DESCRIÇÃO), "ENCARGOS COM INSTALAÇÕES", "NA"))
            contasDF <- mutate(contasDF, RUBRICA = ifelse(grepl("00026322892", DESCRIÇÃO), "SECURITAS - ALARME", "NA"))
    }

    #SMAS
    if (sum(grepl("Servicos Munici", contasDF$DESCRIÇÃO)) > 0) {
            contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = ifelse(grepl("Servicos Munici", DESCRIÇÃO), "ENCARGOS COM INSTALAÇÕES", CENTRO.DE.CUSTO))
            contasDF <- mutate(contasDF, RUBRICA = ifelse(grepl("Servicos Munici", DESCRIÇÃO), "CONSUMO ÁGUA (SMAS)", RUBRICA))
    }

    #Imposto de selo e despesas bancárias
    if (sum(grepl("I.SELO|COMISSÃO MANUTENÇÃO|ANUIDADE|SELO|COMISSAO MANUTENCAO", contasDF$DESCRIÇÃO)) > 0) {
            contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = 
                                       ifelse(grepl("I.SELO|COMISSÃO MANUTENÇÃO", DESCRIÇÃO), 
                                              "ENCARGOS COM INSTALAÇÕES", CENTRO.DE.CUSTO))
            contasDF <- mutate(contasDF, RUBRICA = 
                                       ifelse(grepl("I.SELO|COMISSÃO MANUTENÇÃO", DESCRIÇÃO), "DESP. BANCÁRIAS", RUBRICA))
    }

    # VODAFONE
    if (sum(grepl("00531446107", contasDF$DESCRIÇÃO)) > 0) {
            contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = 
                                       ifelse(grepl("00531446107", DESCRIÇÃO), 
                                              "ENCARGOS COM INSTALAÇÕES", CENTRO.DE.CUSTO))
            contasDF <- mutate(contasDF, RUBRICA = 
                                       ifelse(grepl("00531446107", DESCRIÇÃO), "COMUNICAÇÕES", RUBRICA))
    }

    # MAFEP
    if (sum(grepl("10367661", contasDF$DESCRIÇÃO)) > 0) {
            contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = 
                                       ifelse(grepl("10367661", DESCRIÇÃO), 
                                              "ENCARGOS COM INSTALAÇÕES", CENTRO.DE.CUSTO))
            contasDF <- mutate(contasDF, RUBRICA = 
                                       ifelse(grepl("10367661", DESCRIÇÃO), "ALUGUER EXTINTORES", RUBRICA))
    }


    # EDP - CONSUMO ELECTRICIDADE Jesélia e SUS
    if (sum(grepl("P05100001520", contasDF$DESCRIÇÃO)) > 0) {
            contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = 
                                       ifelse(grepl("P05100001520", DESCRIÇÃO), 
                                              "ENCARGOS COM INSTALAÇÕES", CENTRO.DE.CUSTO))
            contasDF <- mutate(contasDF, RUBRICA = 
                                       ifelse(grepl("P05100001520", DESCRIÇÃO), "CONSUMO ELECTRICIDADE", RUBRICA))
    }

    # Seguros
    if (sum(grepl("11034", contasDF$DESCRIÇÃO)) > 0) {
            contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = 
                                       ifelse(grepl("11034", DESCRIÇÃO), 
                                              "ENCARGOS COM INSTALAÇÕES", CENTRO.DE.CUSTO))
            contasDF <- mutate(contasDF, RUBRICA = 
                                       ifelse(grepl("11034", DESCRIÇÃO), "SEGUROS", RUBRICA))
    }

    # Limpezas
    if (sum(grepl("PT50000700000032524109823", contasDF$DESCRIÇÃO)) > 0) {
            contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = 
                                       ifelse(grepl("PT50000700000032524109823", DESCRIÇÃO), 
                                              "ENCARGOS COM INSTALAÇÕES", CENTRO.DE.CUSTO))
            contasDF <- mutate(contasDF, RUBRICA = 
                                       ifelse(grepl("PT50000700000032524109823", DESCRIÇÃO), "SERVIÇO DE LIMPEZA", RUBRICA))
    }

    # Manutenção e Obras Gaspar Fontes
    if (sum(grepl("PT50003501810000046033029", contasDF$DESCRIÇÃO)) > 0) {
            contasDF <- mutate(contasDF, CENTRO.DE.CUSTO = 
                                       ifelse(grepl("PT50003501810000046033029", DESCRIÇÃO), 
                                              "ENCARGOS COM INSTALAÇÕES", CENTRO.DE.CUSTO))
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
                                              "ENCARGOS COM INSTALAÇÕES", CENTRO.DE.CUSTO))
            contasDF <- mutate(contasDF, RUBRICA = 
                                       ifelse(grepl("PT50003600509910031520496", DESCRIÇÃO), "GÁS", RUBRICA))
    }

Exportação em tabelas para adição de CC e Rubricas manuais
==========================================================

Como algumas despesas não são frequentes, mas sim fruto de necessidades,
ou os fornecedores podem ser os mesmos para diferentes centros de custo
e rúbricas, é exportado um ficheiro excel que será manualmente
alimentado nos campos em falta pela presidencia.

    # Adição de factor de mês para separar a tabela
    contasDF <- contasDF %>% mutate(Mês = as.factor(month(contasDF$DATA.MOV.)))
    contasDF <- contasDF[, c(8, 1:7)] # colocação do factor na coluna inicial

    # Separação da tabela numa lista de tabelas por mês
    listaMes <- split.data.frame(contasDF, contasDF$Mês)

    if (dir.exists("./tabelas_por_mes") == FALSE) dir.create("./tabelas_por_mes")

    library(openxlsx)
    write.xlsx(listaMes, file = "./tabelas_por_mes/tabelas.xlsx")
