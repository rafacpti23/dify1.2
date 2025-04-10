#!/bin/bash

echo -e "\e[34m                                             \e[0m"
echo -e "\e[34m    \e[0m"
echo -e "\e[34m  _______                                     __  \e[0m"       
echo -e "\e[34m /       \                                   /  |      \e[0m"
echo -e "\e[34m $$$$$$$  |  ______   _____  ____    ______  $$ |      \e[0m"
echo -e "\e[34m $$ |__$$ | /      \ /     \/    \  /      \ $$ |      \e[0m"
echo -e "\e[34m $$    $$<  $$$$$$  |$$$$$$ $$$$  |/$$$$$$  |$$ |      \e[0m"
echo -e "\e[34m $$$$$$$  | /    $$ |$$ | $$ | $$ |$$    $$ |$$ |      \e[0m"
echo -e "\e[34m $$ |  $$ |/$$$$$$$ |$$ | $$ | $$ |$$$$$$$$/ $$ |_____ \e[0m"
echo -e "\e[34m $$ |  $$ |$$    $$ |$$ | $$ | $$ |$$       |$$       |\e[0m"
echo -e "\e[34m $$/   $$/  $$$$$$$/ $$/  $$/  $$/  $$$$$$$/ $$$$$$$$/  \e[0m"                                               
echo -e "\e[34m           créditos MAM                      \e[0m"
echo -e "\e[34m          Instalador DifyAI V1               \e[0m"
echo -e "\e[34m         contato@ramelseg.com.br             \e[0m"
echo -e "\e[34m         https://ramelseg.com.br             \e[0m"

# ------------------------------------------------------------------------------
# 1. Garante que git e curl estejam instalados
# ------------------------------------------------------------------------------
if ! command -v git &>/dev/null; then
  echo "Instalando git..."
  sudo apt update && sudo apt install -y git
fi

if ! command -v curl &>/dev/null; then
  echo "Instalando curl..."
  sudo apt update && sudo apt install -y curl
fi

# ------------------------------------------------------------------------------
# 2. Recebe o domínio WEB e o domínio API do usuário e confirma se estão corretos.
# ------------------------------------------------------------------------------
while true; do
  echo "=================================================="
  read -p "Digite o domínio API do Dify (ex: apidify.seusite.com.br): " WEB_DOMAIN
  read -p "Digite o domínio Web console (ex: dify.seusite.com.br): " API_DOMAIN
  
  echo
  echo "Você configurou:"
  echo " - Domínio API: $WEB_DOMAIN"
  echo " - Domínio CONSOLE: $API_DOMAIN"
  echo
  
  read -p "Está correto? (s/n): " CONFIRMA
  if [[ "$CONFIRMA" == "s" || "$CONFIRMA" == "S" ]]; then
    break
  fi
done

# ------------------------------------------------------------------------------
# 3. Atualiza pacotes do sistema.
# ------------------------------------------------------------------------------
echo "=================================================="
echo "Atualizando pacotes..."
sudo apt update && sudo apt upgrade -y

# ------------------------------------------------------------------------------
# 4. Instalação do Docker via script oficial.
# ------------------------------------------------------------------------------
echo "=================================================="
echo "Instalando Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# ------------------------------------------------------------------------------
# 5. Verifica a versão do Docker (teste rápido de instalação).
# ------------------------------------------------------------------------------
echo "=================================================="
docker --version

# ------------------------------------------------------------------------------
# 6. Clona o repositório Dify dentro de /opt (caso não exista).
# ------------------------------------------------------------------------------
echo "=================================================="
if [ ! -d "/opt/dify" ]; then
  echo "Clonando o repositório Dify em /opt..."
  sudo mkdir -p /opt
  sudo git clone https://github.com/langgenius/dify.git /opt/dify
else
  echo "O diretório /opt/dify já existe. Pulando clonagem."
fi

# ------------------------------------------------------------------------------
# 7. Copia o .env.example para .env (substitui se já existir).
# ------------------------------------------------------------------------------
echo "=================================================="
echo "Copiando e atualizando o arquivo .env..."
cd /opt/dify/docker || exit 1

# Caso deseje manter backup do .env antigo, descomente:
# [ -f .env ] && cp .env "env-bkp-$(date +%Y%m%d-%H%M%S)"

cp .env.example .env

# ------------------------------------------------------------------------------
# 8. Ajusta as variáveis do .env usando 'sed'.
# ------------------------------------------------------------------------------
echo "=================================================="
echo "Configurando .env para os domínios informados..."
sed -i "s|^\(CONSOLE_API_URL=\).*|\1https://$API_DOMAIN|g" .env
sed -i "s|^\(CONSOLE_WEB_URL=\).*|\1https://$WEB_DOMAIN|g" .env
sed -i "s|^\(SERVICE_API_URL=\).*|\1https://$API_DOMAIN|g" .env
sed -i "s|^\(APP_API_URL=\).*|\1https://$API_DOMAIN|g" .env
sed -i "s|^\(APP_WEB_URL=\).*|\1https://$WEB_DOMAIN|g" .env

# ------------------------------------------------------------------------------
# 9. Sobe os containers do Dify.
# ------------------------------------------------------------------------------
echo "=================================================="
echo "Iniciando os containers Docker do Dify..."
docker compose up -d

# ------------------------------------------------------------------------------
# 10. Lista os containers para verificação.
# ------------------------------------------------------------------------------
echo "=================================================="
docker ps

#!/bin/bash

# ------------------------------------------------------------------------------
# Mensagem final com ASCII artístico (sem moldura, azul e alinhado)
# ------------------------------------------------------------------------------

echo -e "\e[34m  _ _______    _  ______  _       _    _          _  ___   \e[0m"
echo -e "\e[34m |  ______  \ | ||  ____|\ \    / /    \ \       / // /  | \e[0m"
echo -e "\e[34m | |       \ \| || |____  \ \  / /      \ \     / //_/ | | \e[0m"
echo -e "\e[34m | |       / /| ||  ____|  \ \/ /        \ \   / /     | | \e[0m"
echo -e "\e[34m | |______/ / | || |      ___/ /          \ \ / /      | | \e[0m"
echo -e "\e[34m |_________/  |_||_|     |____/            \___/       |_| \e[0m"
echo
echo -e "\e[34m   _                             _              _          \e[0m"
echo -e "\e[34m  | |                _          | |            | |         \e[0m"
echo -e "\e[34m  | | ____    ___  _| |_  _____ | |  _____   __| |  ___    \e[0m"
echo -e "\e[34m  | ||  _ \  /___)(_   _)(____ || | (____ | / _  | / _ \   \e[0m"
echo -e "\e[34m  | || | | ||___ |  | |_ / ___ || | / ___ |( (_| || |_| |  \e[0m"
echo -e "\e[34m  |_||_| |_|(___/    \__)\_____| \_)\_____| \____| \___/   \e[0m"
echo
echo -e "\e[37m      Instalação concluída com sucesso!                     \e[0m"
echo -e "\e[37mVocê pode agora acessar o DifyAI em:                       \e[0m"
echo -e "\e[32mhttps://$WEB_DOMAIN\e[0m"
echo -e "\e[37mAPI disponível em:                                         \e[0m"
echo -e "\e[32mhttps://$API_DOMAIN\e[0m"
echo
echo -e "\e[34mRamel Tecnologia:                                           \e[0m"
echo -e "\e[34mhttps://ramelseg.com.br\e[0m"

