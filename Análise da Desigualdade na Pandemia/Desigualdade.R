



getwd()
setwd('D:/Programação e Projetos/R/Projetos/ScripR/Análise da Desigualdade na Pandemia')

# Instalando o Pacote para analisar a PnadCovid----
install.packages("COVIDIBGE")
library(COVIDIBGE)
help("get_covid")

dadosPNADCOVID19 <- get_covid(year = 2020, month = 5)
class(dadosPNADCOVID19)

# Salvando para não precisar chamar novamente
saveRDS(dadosPNADCOVID19, file = "dados_2020_05.rds")

# para chamar do rds, fazer:
dadosPNADCOVID_2020_05 <- readRDS("D:/Programação e Projetos/R/Projetos/ScripR/Análise da Desigualdade na Pandemia/dados_2020_05.rds")


# Se quisermos trabalhar somente algumas variaveis ----
dadosPNADCOVID19 <- get_covid(year = 2020, month = 5, vars = c("C001", "C002"))
# o comando abaixo traz as caracteristicas do plano amostral
dadosPNADCOVID19
# vendo a classe do objeto: 'survey.design2' 'survey.design'
class(dadosPNADCOVID19)  # 'survey.design2' 'survey.design'
# vou salvar para não precisar chamar novamente
saveRDS(dadosPNADCOVID19, file = "dados_2020_05_srv.rds")

# com desing false: retorna tibble design
dadosPNADCOVID19_brutos <- get_covid(year = 2020, month = 5, vars = c("C001", "C002"),
                                     design = FALSE)
class(dadosPNADCOVID19_brutos)  # 'tbl_df'     'tbl'        'data.frame'
dadosPNADCOVID19_brutos
saveRDS(dadosPNADCOVID19_brutos, file = "dados_2020_05_df.rds")

# Sem labels
dadosPNADCOVID19_brutos_sem <- get_covid(year = 2020, month = 5, vars = c("C001",
                                                                          "C002"), labels = FALSE, design = FALSE)
# os níveis das categorias são representados por números: UF Rondônia = 11
dadosPNADCOVID19_brutos_sem
saveRDS(dadosPNADCOVID19_brutos_sem, file = "dados_2020_05_df_sem.rds")

dadosPNADCOVID19_brutos

dadosPNADCOVID19 <- read_covid(microdata = "PNAD_COVID_052020.csv")
#
dadosPNADCOVID19 <- covid_labeller(data_covid = dadosPNADCOVID19, dictionary.file = "Dicionario_PNAD_COVID_052020_20210726.xls")
#
class(dadosPNADCOVID19)  # [1] 'tbl_df'     'tbl'        'data.frame'

dadosPNADCOVID19 <- covid_deflator(data_covid = dadosPNADCOVID19, deflator.file = "Deflator_PNAD_COVID_2020_11.xls")
class(dadosPNADCOVID19)  # 'tbl_df'     'tbl'        'data.frame'

####
dadosPNADCOVID19 <- covid_design(data_covid = dadosPNADCOVID19)
class(dadosPNADCOVID19)  # 'survey.design2' 'survey.design' 
#
dadosPNADCOVID19
# Stratified 1 - level Cluster Sampling design (with replacement) With (14906)
# clusters.  survey::postStratify(design = data_prior, strata = ~posest,
# population = popc.types) posso salvar para depois
saveRDS(dadosPNADCOVID19, file = "dados_2020_05_final.rds")

###
variaveis_selecionadas <- c("UF", "A002", "A003", "A004", "A005", "C001", "C002",
                            "C003", "C008", "C01012")
dadosPNADCOVID19.var <- get_covid(year = 2020, month = 5, vars = variaveis_selecionadas)
class(dadosPNADCOVID19.var)
saveRDS(dadosPNADCOVID19.var, file = "dados_2020_05_var.rds")

###
names(dadosPNADCOVID19.var[["variables"]])
# [1] 'Ano' 'V1013' 'UF' 'V1008' [5] 'V1012' 'Estrato' 'UPA' 'V1030' [9]
# 'V1031' 'V1032' 'posest' 'A001' [13] 'A002' 'A003' 'A004' 'A005' [17] 'C001'
# 'C002' 'C003' 'C008' [21] 'C01012' 'ID_DOMICILIO' 'Habitual' 'Efetivo' [25]
# 'CO3'
install.packages("srvyr")
library(srvyr)
#
pnad_srvyr <- srvyr::as_survey(dadosPNADCOVID19)
saveRDS(pnad_srvyr, file = "pnad_srvyr.rds")
class(pnad_srvyr)
# 'tbl_svy' 'survey.design2' 'survey.design' posso selecionar as colunas
# simplesmente fazendo
variaveis <- c("Ano", "V1013", "UF", "V1008", "V1012", "Estrato", "UPA", "V1030",
               "V1031", "V1032", "posest", "A001", "A002", "A003", "A004", "A005", "C001", "C002",
               "C003", "C008", "C01012", "ID_DOMICILIO", "Habitual", "Efetivo", "CO3")
# usar select() in dplyr
pnad_srvyr_select <- pnad_srvyr %>%
  select(variaveis)
class(pnad_srvyr_select)
saveRDS(pnad_srvyr_select, file = "pnad_srvyr_select.rds")

names(pnad_srvyr_select[["variables"]])
# [1] 'Ano' 'V1013' 'UF' 'V1008' 'V1012' [6] 'Estrato' 'UPA' 'V1030' 'V1031'
# 'V1032' [11] 'posest' 'A001' 'A002' 'A003' 'A004' [16] 'A005' 'C001' 'C002'
# 'C003' 'C008' [21] 'C01012' 'ID_DOMICILIO' 'Habitual' 'Efetivo' 'CO3'
# comparar com o names de pnad_srvyr
names(pnad_srvyr[["variables"]])  # retornam 117 variaveis

##
dadosPNADCOVID19.var <- readRDS("D:/Programação e Projetos/R/Projetos/ScripR/Análise da Desigualdade na Pandemia/dados_2020_05_var.rds")
# Manipulando as variáveis -----
pnad_srvyr_select <- readRDS("D:/Programação e Projetos/R/Projetos/ScripR/Análise da Desigualdade na Pandemia/pnad_srvyr_select.rds")
install.packages("survey")
library(survey)
# compararei as duas abordagens: survey.design x 'tbl_svy'
totalrenda1 <- svytotal(x = ~C01012, design = dadosPNADCOVID19.var, na.rm = TRUE)
totalrenda2 <- svytotal(x = ~C01012, design = pnad_srvyr_select, na.rm = TRUE)
totalrenda1


totalrenda2
cv(object = totalrenda1)
cv(object = totalrenda2)
confint(object = totalrenda2)
confint(object = totalrenda1, level = 0.99)
confint(object = totalrenda2, level = 0.99)
help(confint)

# usarei um coringa x para depois compor uma rotina iterativa entre arquivos
x <- dadosPNADCOVID19.var

###
library(tidyverse)
install.packages("convey")
library(convey)
library(survey)
totalsexo <- svytotal(x = ~A003, design = x, na.rm = TRUE)
totalsexo
totalsexoraca <- svytotal(x = ~A003 + A004, design = x, na.rm = TRUE)
totalsexoraca


totalsexoEraca <- svytotal(x = ~interaction(A003, A004), design = x, na.rm = TRUE)
ftable(x = totalsexoEraca)


mediarenda <- svymean(x = ~C01012, design = x, na.rm = TRUE)
mediarenda

# 10.1 Cálculo dos coeficientes de variação e intervalos de confiança
cv(object = mediarenda)

confint(object = mediarenda)

# 11 ESTIMAÇÃO DE PROPORÇÕES
propsexo <- svymean(x = ~A003, design = x, na.rm = TRUE)
propsexo

# 11.1 Proporção de mais de uma variável:
propsexoraca <- svymean(x = ~A003 + A004, design = x, na.rm = TRUE)
propsexoraca

# 11.2 Cruzamento de duas ou mais variáveis com a função interaction:
propsexoEraca <- svymean(x = ~interaction(A003, A004), design = x, na.rm = TRUE)
ftable(x = propsexoEraca)

# 12 ESTIMAÇÃO DE RAZÕES (RATIOS) OU TAXAS
txafastquarentena <- svyratio(numerator = ~(C003 == "Estava em quarentena, isolamento, distanciamento social ou férias coletivas"),
                              denominator = ~(C002 == "Sim"), design = x, na.rm = TRUE)
txafastquarentena


# 12.1 Intervalos de confiança e coeficiente de variação:
cv(object = txafastquarentena)

confint(object = txafastquarentena)


# 13 ESTIMAÇÃO DE MEDIANAS E QUANTIS
# 13.1 Mediana
medianarenda <- svyquantile(x = ~C01012, design = x, quantiles = 0.5, na.rm = TRUE)
medianarenda

# 13.2 Intervalo de confiança
medianarenda <- svyquantile(x = ~C01012, design = x, quantiles = 0.5, ci = TRUE,
                            na.rm = TRUE)
medianarenda

# 13.3 Desvio-padrão e coeficiente de variação
SE(object = medianarenda)
cv(object = medianarenda)

# 13.4 Múltiplos quantis
quantisrenda <- svyquantile(x = ~C01012, design = x, quantiles = c(0.1, 0.25, 0.5,
                                                                   0.75, 0.9), na.rm = TRUE)
quantisrenda

# 14 ESTIMAÇÃO PARA VARIÁVEIS DE RENDIMENTO DEFLACIONADAS
# 14.1 Criar variável rendimento deflacionada
x$variables <- transform(x$variables, C01012_real = C01012 * Habitual)

# 14.2 Estimativa do total
totalrenda_real <- svytotal(x = ~C01012_real, design = x, na.rm = TRUE)
totalrenda_real

# 14.3 Média
mediarenda_real <- svymean(x = ~C01012_real, design = x, na.rm = TRUE)
mediarenda_real

# 15 ESTIMAÇÃO PARA UM DOMÍNIO
mediarendaM <- svymean(x = ~C01012, design = subset(x, A003 == "Mulher"), na.rm = TRUE)
mediarendaM

# 15.1 Condicionais com desigualdade
txafastquarentena25 <- svyratio(numerator = ~(C003 == "Estava em quarentena, isolamento, distanciamento social ou férias coletivas"),
                                denominator = ~(C002 == "Sim"), design = subset(x, A002 >= 25), na.rm = TRUE)
txafastquarentena25

# 15.2 Utilizando múltiplas condições com os operadores lógicos & (“e”) e | (“ou”)
# Esse caso serve para obter frequências relativas de cada nível (aqui utilizamos para o nível de instrução) para sexo = “Homem” e raça = “Parda”, com Idade (A002) “>30” anos.

nivelinstrHP30 <- svymean(x = ~A005, design = subset(x, A003 == "Homem" & A004 ==
                                                       "Parda" & A002 > 30), na.rm = TRUE)
nivelinstrHP30

nivelinstrHB30 <- svymean(x = ~A005, design = subset(x, A003 == "Homem" & A004 ==
                                                       "Branca" & A002 > 30), na.rm = TRUE)
nivelinstrHB30

# 15.3 Múltiplas análises em um mesmo domínio
# Neste caso, faz-se uma subamostra usando a função subset.

dadosPNADCOVID19_mulheres <- subset(x, A003 == "Mulher")
dadosPNADCOVID19_mulheres

# 16 ESTIMAÇÕES PARA VÁRIOS DOMÍNIOS
# 16.1 Estimação de quantidades em vários domínios mutuamente exclusivos
# Homem x Mulher em cada nível de instrução:

freqSexoInstr <- svyby(formula = ~A003, by = ~A005, design = x, FUN = svymean, na.rm = TRUE)
freqSexoInstr

# 16.2 Frequência relativa de cada nível de instrução para cada sexo
freqInstrSexo <- svyby(formula = ~A005, by = ~A003, design = x, FUN = svymean, na.rm = TRUE)
freqInstrSexo

# 16.3 Renda média normalmente recebida em dinheiro (C01012) por Unidade da Federação (UF)
mediaRendaUF <- svyby(formula = ~C01012, by = ~UF, design = x, FUN = svymean, na.rm = TRUE)
mediaRendaUF

# farei tambem pelo objeto srvyr
library(srvyr)
mediaRendaUF2 <- pnad_srvyr_select %>%
  group_by(UF) %>%
  summarise(media = survey_mean(C01012, na.rm = T, vartype = "ci"))
mediaRendaUF2

# 16.4 Intervalo de confiança de (C01012) x (UF)
confint(object = mediaRendaUF)

library(ggplot2)
ggplot(as.data.frame(mediaRendaUF2), aes(x = UF, y = media)) + geom_point() + geom_errorbar(aes(ymin = media_low,
                                                                                                ymax = media_upp), width = 0.2) + theme(axis.text.x = element_text(angle = 90)) +
  labs(title = "Rendimento Médio Domiciliar Estadual", caption = "Fonte: IBGE-PNADC, elaboração própria.")

# 16.5 Cruzamentos de variáveis categóricas com a função interaction
txafastquarentenaSexoRaca <- svyby(formula = ~(C003 == "Estava em quarentena, isolamento, distanciamento social ou férias coletivas"),
                                   denominator = ~(C002 == "Sim"), by = ~interaction(A003, A004), design = x, FUN = svyratio,
                                   vartype = "cv", na.rm = TRUE)
txafastquarentenaSexoRaca

# 17 GRÁFICOS PARA DADOS AMOSTRAIS via survey
# 17.1 Histograma
svyhist(formula = ~as.numeric(C008), design = x, main = "Histograma com densidade",
        xlab = "Número de Horas Normalmente Trabalhadas")
svyhist(formula = ~as.numeric(C008), design = x, freq = TRUE, main = "Histograma com frequências absolutas",
        xlab = "Número de Horas Normalmente Trabalhadas")

# 17.2 Boxplot
# 17.2.1 Sem usar grupos
svyboxplot(formula = C008 ~ 1, design = x, main = "Boxplot do Número de Horas Normalmente Trabalhadas")


# 17.2.2 Com grupos definidos por variável
svyboxplot(formula = C008 ~ A003, design = x, main = "Boxplot do Número de Horas Normalmente Trabalhadas por Sexo")

# 17.3 Boxplot com todos os outliers
# A opção anterior plotava apenas os outliers extremos. Agora têm-se todos os outliers.

svyboxplot(formula = C008 ~ A003, design = x, all.outliers = TRUE, main = "Boxplot do Número de Horas Normalmente Trabalhadas por Sexo")

# 17.4 Gráficos de dispersão
# 17.4.1 Estilo bolha
svyplot(formula = C01012 ~ C008, design = x, style = "bubble", xlab = "Número de Horas Normalmente Trabalhadas",
        ylab = "Rendimento Normalmente Recebido em Dinheiro")


# 17.4.2 Estilo transparente
svyplot(formula = C01012 ~ C008, design = x, style = "transparent", xlab = "Número de Horas Normalmente Trabalhadas",
        ylab = "Rendimento Normalmente Recebido em Dinheiro")

# 8 MODELAGEM COM PACOTE survey
# 18.1 Testes de Hipóteses
# 18.1.1 Teste-t para médias de rendimentos entre sexos
svyttest(formula = C01012 ~ A003, design = x)


#  18.1.2 Teste-t para médias de horas trabalhadas (C008) entre quem trabalhou ou não (C001)
svyttest(formula = as.numeric(C008) ~ C001, design = x)

# 18.2 Modelos lineares
# 18.2.1 Regressão linear
modeloLin <- svyglm(formula = C01012 ~ A005 + A004 + A002, design = x)
summary(object = modeloLin)

confint(object = modeloLin)


# 18.2.2 Regressão Logística
modeloLog <- svyglm(formula = C002 ~ A003 + A004 + A002, design = x, family = "binomial")

summary(object = modeloLog)

# 19 ANÁLISE DE CONCENTRAÇÃO DE RENDA COM O PACOTE convey
# O pacote convey requer uso da função convey_prep para adaptar o objeto do plano amostral do survey ao objeto que o pacote convey requer para as estimações (JACOB et al, 2021):

# para fazer o gini, precisa aplicar o convey_prep para usar o convey
library(convey)
dadosPNADCOVID19 <- convey_prep(design = x)
x <- dadosPNADCOVID19  # vou reatribuir
class(x)  # 'convey.design'  'survey.design2' 'survey.design' 

# 19.1 Índice de Gini
giniHab <- svygini(formula = ~C01012, design = x, na.rm = TRUE)
giniHab
cv(object = giniHab)


# 19.2 Índice de Gini da renda normalmente recebida em dinheiro por Unidade da Federação:
giniUF <- svyby(formula = ~C01012, by = ~UF, design = x, FUN = svygini, na.rm = TRUE)
giniUF

confint(object = giniUF)


# 19.3 Curva de Lorenz
curvaLorenz <- svylorenz(formula = ~C01012, design = x, quantiles = seq(0, 1, 0.05),
                         na.rm = TRUE)

