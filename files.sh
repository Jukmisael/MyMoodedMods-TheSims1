#!/bin/bash

# Define o nome dos arquivos de saída
README="Readme.md"
FILELIST="filelist.txt"

# Limpa os arquivos de saída existentes
> $README
> $FILELIST

# Função recursiva para processar cada arquivo e pasta
process() {
    local path="$1"
    for file in "$path"/*; do
        # Ignora os arquivos README, arquivo de lista de arquivos e pastas vazias
        if [[ $file != $README && $file != $FILELIST && -n "$(ls -A "$file")" ]]; then
            # Adiciona o caminho do arquivo ou pasta ao arquivo de lista de arquivos
            echo "$file" >> $FILELIST
            
            # Se for uma pasta, chama a função process recursivamente
            if [[ -d "$file" ]]; then
                process "$file"
            # Se for um arquivo, calcula o hash MD5 e adiciona informações do arquivo ao arquivo README
            elif [[ -f "$file" ]]; then
                hash=$(md5sum "$file" | awk '{ print $1 }')
                echo "## $file" >> $README
                echo "- Caminho: $file" >> $README
                echo "- Hash MD5: $hash" >> $README
                echo "" >> $README
            fi
        fi
    done
}

# Chama a função process com o diretório atual como argumento
process "$(pwd)"

# Imprime mensagem de conclusão
echo "Arquivos e pastas e seus hashes MD5 foram exportados com sucesso para $README e $FILELIST."
