#!/bin/bash

# Define o nome dos arquivos de entrada e saída
FILELIST="FilesList.md"
LINKFILE="pixeldrain-link.txt"

# Limpa o arquivo de saída existente
> $LINKFILE

# Cria uma pasta temporária para armazenar os arquivos agrupados
tempdir=$(mktemp -d)

# Loop sobre cada linha no arquivo de lista de arquivos
while read -r line; do
    # Extrai o caminho do arquivo
    path=$(echo "$line" | sed 's/^- //')
    
    # Extrai a extensão do arquivo (se houver)
    extension="${path##*.}"
    
    # Se não houver extensão, pula para a próxima linha
    if [[ -z "$extension" ]]; then
        continue
    fi
    
    # Cria a pasta para a extensão, se ainda não existir
    extension_dir="$tempdir/$extension"
    mkdir -p "$extension_dir"
    
    # Copia o arquivo para a pasta da extensão
    cp "$path" "$extension_dir/"
done < "$FILELIST"

# Compacta as pastas de extensões em um arquivo zip
zipfile="FilesGroupedByExtension.zip"
zip -r "$zipfile" "$tempdir"

# Faz o upload do arquivo zip para o Pixeldrain e obtém o link compartilhável
link=$(curl -s -X POST --form "file=@$zipfile" https://pixeldrain.com/api/file)

# Escreve o link no arquivo de saída
echo "Link do arquivo zip: $link" >> $LINKFILE

# Limpa a pasta temporária
rm -rf "$tempdir"

# Imprime mensagem de conclusão
echo "Arquivos foram agrupados por extensão e enviados para o Pixeldrain com sucesso. Link: $link"
