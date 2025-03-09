#!/usr/bin/env bash

echo -e "\e[1;32m🚀 Setting up HTTPS authentication for GitHub using Personal Access Token...\e[0m"

# Load environment variables from .env if it exists
if [ -f .env ]; then
    echo -e "\e[1;33m📝 Loading environment variables from .env...\e[0m"
    set -a  # Automatically export variables
    source .env
    set +a
else
    echo -e "\e[1;31m⚠️ .env file not found! Please create it with the necessary variables.\e[0m"
    exit 1
fi

# Check if GITHUB_TOKEN environment variable is set
if [ -z "$GITHUB_TOKEN" ]; then
    echo -e "\e[1;31m⚠️ GITHUB_TOKEN is not set. Please set your GitHub token in the environment variable.\e[0m"
    exit 1
fi

# Authenticate with GitHub using HTTPS and Personal Access Token (PAT)
echo -e "\e[1;33m🔑 Authenticating with GitHub using Personal Access Token...\e[0m"

# Configure Git to use the token for HTTPS authentication
git config --global credential.helper store

# Test authentication by checking if the repository is accessible
if git ls-remote https://$GITHUB_TOKEN@github.com/strayder90/table-tune.git &>/dev/null; then
    echo -e "\e[1;32m✅ Authentication successful!\e[0m"
else
    echo -e "\e[1;31m❌ Authentication failed! Please check your GitHub token.\e[0m"
    exit 1
fi

# Clone the repository using HTTPS and authenticate automatically
if [ ! -d "table-tune" ]; then
    echo -e "\e[1;32m📥 Cloning table-tune repository...\e[0m"
    git clone https://$GITHUB_TOKEN@github.com/strayder90/table-tune.git
else
    echo -e "\e[1;33m⚠️ A table-tune repo already exists. Skipping clone.\e[0m"
fi

cd table-tune

# Set up Git user details
git config --global user.name "Strayder90"
git config --global user.email "strayder@live.com"
git config --global user.username "Strayder"
git config --global init.defaultbranch "master"
git config --global core.autocrlf "input"
git config --global core.safecrlf "true"
git config --global core.fscache "true"
git config --global core.symlinks "false"
git config --global http.sslbackend "openssl"
git config --global http.sslcainfo "/etc/ssl/certs/ca-certificates.crt"
git config --global diff.astextplain.textconv "astextplain"
git config --global filter.lfs.clean "git-lfs clean -- %f"
git config --global filter.lfs.smudge "git-lfs smudge -- %f"
git config --global filter.lfs.process "git-lfs filter-process"
git config --global filter.lfs.required "true"
git config --global credential.helper "libsecret"
git config --global pull.rebase "false"
git config --global credential.https://dev.azure.com.usehttppath "true"
git config --global push.default "current"

# Set up Git aliases
git config --global alias.ch "checkout"
git config --global alias.br "branch"
git config --global alias.chnb "checkout -b"
git config --global alias.cm "commit"
git config --global alias.amend "commit --amend"
git config --global alias.st "status"
git config --global alias.lg "log --oneline --graph --all"
git config --global alias.last "log -1 HEAD"
git config --global alias.aliases "config --get-regexp alias"

echo -e "\e[1;32m✅ Git configuration complete!\e[0m"

# Pull the latest changes from GitHub
echo -e "\e[1;32m🔄 Pulling latest changes from GitHub...\e[0m"
git pull origin main

# Start Docker services
echo -e "\e[1;32m🐳 Starting Docker Compose...\e[0m"
docker compose up -d --build

# Open the application in Chrome
echo -e "\e[1;34m🌐 Opening the application in Google Chrome...\e[0m"
google-chrome http://localhost:5173

echo -e "\e[1;32m✅ Setup complete! You can now work on the project.\e[0m"
