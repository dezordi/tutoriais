## primeira tarefa
#carregando a biblioteca dplyr
library(dplyr)
#lendo os resultados tabulares do blast
resultados_blast <- read.table("https://raw.githubusercontent.com/dezordi/tutoriais/main/01_python_e_r/blast.output.tsv", header = TRUE, sep = "\t")
#lendo os resultados tabulares do blast
banco_de_dados <- read.table("https://raw.githubusercontent.com/dezordi/tutoriais/main/01_python_e_r/db.tsv", header = TRUE, sep = "\t")
#filtrando os resultados pela identidade e 
resultados_blast_filtrados_anotados <- resultados_blast %>% filter(pident >= 60) %>% 
  filter(!duplicated(qseqid)) %>% #removendo as demais linhas para a mesma sonda
  merge(banco_de_dados, by.x = "sseqid", by.y = "Accession", all.x = TRUE, all.y = FALSE) ##anotando os resultados do blast com as informações presentes no banco de dados
#mostrando os resultados na tela do terminal
print(resultados_blast_filtrados_anotados[, c("qseqid", "Family", "Genus", "Species", "Protein")])

## segunda tarefa
#carregando a biblioteca ggplot2
library(ggplot2)
#sumarizando o tamanho dos alinhamentos por espécie
tamanho_por_especie_viral <- resultados_blast_filtrados_anotados %>% group_by(Species) %>% summarize(length = sum(length))
#transformando os valores em porcentagem
tamanho_por_especie_viral$length <- prop.table(tamanho_por_especie_viral$length)
#criando o gráfico
plot <- ggplot(tamanho_por_especie_viral, aes(x="", y = length, fill = Species)) +
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y", start = 0) +
  ggtitle("Criando o plot com R") + #adicionando o título do gráfico
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks=element_blank())+
  geom_text(aes(label = paste0(round(length*100, 2),"%")), position = position_stack(vjust = 0.5))
#mostrando o gráfico em uma interface que permite realizar algumas modificações e salvá-lo como png
plot

##terceira tarefa
#caregando a biblioteca plotly
library(plotly)
#obtendo o número de sequências por país
sequencias_por_pais <- resultados_blast_filtrados_anotados %>% group_by(Country) %>% summarize(sequencias = n())
#criando o gráfico
fig <- plot_geo(data = sequencias_por_pais,
                locations = ~Country,
                locationmode = "country names",
                color = ~sequencias,
                size = ~sequencias,
                hover_name = ~Country,
                title = "Número de sequencias por país")
#mostrando o gráfico em uma interface que permite realizar algumas modificações e salvá-lo como png
fig
