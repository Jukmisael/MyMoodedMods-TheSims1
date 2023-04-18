#!/bin/bash

# Define o nome dos arquivos de saída
README="Readme.md"
FILELIST="filelist.txt"

# Limpa os arquivos de saída existentes
> $README
> $FILELIST

# Loop através de todos os arquivos e pastas no diretório atual
for file in *; do
    # Ignora o arquivo README e o arquivo de lista de arquivos
    if [[ $file != $README && $file != $FILELIST ]]; then
        # Adiciona o caminho do arquivo ao arquivo de lista de arquivos
        echo "$(pwd)/$file" >> $FILELIST
        
        # Calcula o hash MD5 do arquivo
        hash=$(md5sum "$file" | awk '{ print $1 }')
        
        # Adiciona informações do arquivo ao arquivo README
        echo "## $file" >> $README
        echo "- Caminho: $(pwd)/$file" >> $README
        echo "- Hash MD5: $hash" >> $README
        echo "" >> $README
    fi
done

# Imprime mensagem de conclusão
echo "Arquivos e pastas e seus hashes MD5 foram exportados com sucesso para $README e $FILELIST."
echo " "
