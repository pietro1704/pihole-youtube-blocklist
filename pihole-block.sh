#!/bin/bash

# URL das listas de bloqueio
URLS=(
  "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
  "https://mirror1.malwaredomains.com/files/justdomains"
  "https://someonewhocares.org/hosts/hosts"
  "https://adaway.org/hosts.txt"
  "https://winhelp2002.mvps.org/hosts.txt"
  "https://adguard.com/en/filter-rules.html?id=15"
  "https://easylist.to/easylist/easylist.txt"
  "https://fanboy.co.nz/fanboy-enhanced.txt"
)

# URL das regras regex personalizadas
REGEX_URL="https://raw.githubusercontent.com/yourusername/pihole-youtube-blocklist/main/youtube-regex.list"


# Diretório de armazenamento temporário
TEMP_DIR="/tmp/pihole-temp"

# Criar diretório temporário
mkdir -p $TEMP_DIR

# Atualizar listas de bloqueio
for URL in "${URLS[@]}"; do
  curl -sSL $URL | grep '^0\.0\.0\.0' | awk '{print $2}' > $TEMP_DIR/$(basename $URL)
done

# Atualizar regras regex personalizadas
curl -sSL $REGEX_URL > $TEMP_DIR/youtube-regex.list

# Atualizar Pi-hole com as novas listas e regras
for FILE in $TEMP_DIR/*; do
  docker exec pihole pihole -b -l $FILE
done

# Reiniciar o serviço Pi-hole
docker exec pihole pihole restartdns

# Limpar diretório temporário
rm -r $TEMP_DIR

