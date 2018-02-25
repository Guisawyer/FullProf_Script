# --- Modo de Refinamento Para o Método de Lebail --- #

# --- Ordem do Refinamento --- # Para NÃO refinar um determinado parâmetro basta por o # ANTES do parâmetro

PARAMETROS_REDE           # Refinar os Parâmetros da Célula Unitária (a, b e c) #
PARAMETROS_UVW            # Refinar a Largura à Meia Altura dos Picos por Meio dos Parâmetros U, V e W #
PARAMETRO_SHAPE           # Refinar o Shape #
PARAMETROS_XY             # Refinar o X e Y #
paramBack                 # Refinar o Background #
paramZERO                 # Refinar o Deslocamento do Zero da Escala 2θ #

# --- Refinando o que deram de Errado e Finalizando --- #

Exec_Erros
Finalizando
