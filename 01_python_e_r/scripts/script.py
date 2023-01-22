## primeira tarefa
#carregando a biblioteca pandas com o nome de pd
import pandas as pd
#lendo os resultados tabulares do blast
resultados_blast = pd.read_table("https://raw.githubusercontent.com/dezordi/tutoriais/main/01_python_e_r/blast.output.tsv")
#lendo o banco de dados tabular
banco_de_dados = pd.read_table("https://raw.githubusercontent.com/dezordi/tutoriais/main/01_python_e_r/db.tsv")
#filtrando os resultados pela identidade e removendo as demais linhas para a mesma sonda
resultados_blast_filtrados = resultados_blast.query("pident >= 60").drop_duplicates(subset="qseqid", keep="first")
#anotando os resultados do blast com as informações presentes no banco de dados
resultados_blast_filtrados_anotados = pd.merge(resultados_blast_filtrados, banco_de_dados, left_on='sseqid', right_on='Accession')
#mostrando os resultados na tela do terminal
print(resultados_blast_filtrados_anotados[["qseqid", "Family", "Genus", "Species", "Protein"]])

## segunda tarefa
#carregando o módulo pyplot da biblioteca matplotlib com o nome de plt
import matplotlib.pyplot as plt
#sumarizando o tamanho dos alinhamentos por espécie
tamanho_por_especie_viral = resultados_blast_filtrados_anotados.groupby("Species")["length"].sum()
#criando o gráfico
plt.pie(tamanho_por_especie_viral, labels=tamanho_por_especie_viral.index, autopct='%1.1f%%', startangle=90, counterclock=False, pctdistance=0.6)
#assegurando que o gráfico está em formato circular
plt.axis('equal')
#adicionando o título do gráfico
plt.title("Criando o plot com Python")
#mostrando o gráfico em uma interface que permite realizar algumas modificações e salvá-lo como png
plt.show()

## terceira tarefa
#carregando o método express da biblioteca plotly como px
import plotly.express as px
#obtendo o número de sequências por país
sequencias_por_pais = resultados_blast_filtrados_anotados.groupby("Country").size().reset_index(name='sequencias')
#criando o gráfico
fig = px.scatter_geo(data_frame=sequencias_por_pais,
                     locations=sequencias_por_pais['Country'],
                     locationmode='country names',
                     color=sequencias_por_pais['sequencias'],
                     size=sequencias_por_pais['sequencias'],
                     hover_name=sequencias_por_pais['Country'],
                     title='Número de sequencias por país',
                     )
#mostrando o gráfico em uma interface que permite realizar algumas modificações e salvá-lo como png
fig.show()