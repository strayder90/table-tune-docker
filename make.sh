#!/usr/bin/env bash

set -e

echo -e "\033[1;32m🚀 Add table-tune to /etc/hosts? (y/n)\033[0m"
read -r updateHosts

updateHosts=$(echo "$updateHosts" | tr '[:upper:]' '[:lower:]')

if [ "$updateHosts" = "y" ]; then
  if ! grep -q "127.0.0.1 table-tune" /etc/hosts; then
    echo "127.0.0.1 table-tune" | sudo tee -a /etc/hosts
    echo -e "\033[1;32m✅ table-tune added to /etc/hosts!\033[0m"
  else
    echo -e "\033[1;33m⚠️ table-tune already exists in /etc/hosts.\033[0m"
  fi
fi

if [ -f .env ]; then
    echo -e "\e[1;33m📝 Loading environment variables from .env...\e[0m"
    set -a
    source .env
    set +a
else
    echo -e "\e[1;31m⚠️ There is no .env file found! Please create it with the necessary variables.\e[0m"

    echo -e "\033[1;32mGenerate .env with FE credentials (y/n)?\033[0m"
    read -r generateEnv

    if [ "$generateEnv" = "y" ]; then
      echo -e "\033[1;32mPlease provide FE_APP_PATH\033[0m"
      read -r FE_APP_PATH
      echo -e "### local env" > .env
      echo "FE_APP_PATH=$FE_APP_PATH" >> .env
    fi

    if [ -z "$FE_APP_PATH" ]; then
      echo -e "\033[1;31m❌ FE_APP_PATH is not set! Exiting...\033[0m"
      exit 1
    fi

    echo -e "\033[1;32mGenerate .env.local with GitHub token (y/n)?\033[0m"
    read -r generateEnvLocal

    if [ "$generateEnvLocal" = "y" ]; then
      echo -e "\033[1;32mPlease provide the GitHub token:\033[0m"
      read -r GITHUB_TOKEN
      echo -e "### app_auth" > .env.local
      echo "APP_AUTH='{\"github-token\": {\"git@github.com\": {\"username\": \"\", \"token\": \"$GITHUB_TOKEN\"}}}'" >> .env.local
    fi

    if [ -z "$GITHUB_TOKEN" ]; then
      echo -e "\033[1;31m❌ GitHub token is required! Exiting...\033[0m"
      exit 1
    fi
fi

if git ls-remote https://"$GITHUB_TOKEN"@github.com/strayder90/table-tune.git &>/dev/null; then
    echo -e "\e[1;32m✅ Authentication successful!\e[0m"
else
    echo -e "\e[1;31m❌ Authentication failed! GitHub token is required!\e[0m"
    exit 1
fi

echo -e "\033[1;32mCloning table-tune repository...\033[0m"

if [ ! -d "$FE_APP_PATH" ]; then
  git clone "https://$GITHUB_TOKEN@github.com/strayder90/table-tune.git" "$FE_APP_PATH"
  echo -e "\033[1;32m✅ Repository cloned successfully!\033[0m"
else
  echo -e "\033[1;33m⚠️ Repository already exists at $FE_APP_PATH. Skipping clone.\033[0m"
fi

echo -e "\033[1;32mSetting correct permissions...\033[0m"
sudo chown -R "$(whoami):$(whoami)" "$FE_APP_PATH"
sudo chmod -R 777 "$FE_APP_PATH"

echo -e "\033[1;32m🐳 Starting Docker Compose...\033[0m"
docker compose up --build -d

echo -e "\033[1;32m✅ Setup complete! You can now work on the project.\033[0m"
