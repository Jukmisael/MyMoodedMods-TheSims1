#!/bin/bash

# Define o nome dos arquivos de saída
FILELIST="FilesList.md"
HASHFILE="HashList.txt"

# Limpa os arquivos de saída existentes
> $FILELIST
> $HASHFILE

# Função recursiva para processar cada arquivo e pasta
process() {
    local path="$1"
    for file in "$path"/*; do
        # Ignora os arquivos FilesList.md, HashList.txt e pastas vazias
        if [[ $file != $FILELIST && $file != $HASHFILE && -n "$(ls -A "$file")" ]]; then
            # Adiciona o caminho do arquivo ou pasta ao arquivo de lista de arquivos
            echo "- $file" >> $FILELIST
            
            # Se for uma pasta, chama a função process recursivamente
            if [[ -d "$file" ]]; then
                process "$file"
            # Se for um arquivo, calcula o hash MD5 e adiciona informações do arquivo ao arquivo de hash
            elif [[ -f "$file" ]]; then
                hash=$(md5sum "$file" | awk '{ print $1 }')
                echo "$hash $file" >> $HASHFILE
            fi
        fi
    done
}

# Chama a função process com o diretório atual como argumento
process "$(pwd)"

# Imprime mensagem de conclusão
echo "Arquivos e pastas e seus hashes MD5 foram exportados com sucesso para $FILELIST e $HASHFILE."
