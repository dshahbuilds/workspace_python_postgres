#!/bin/bash
set -e # Exit on any error

echo "🚀 Starting Sandbox Environment Setup..."

# 1. System Updates
sudo apt-get update
sudo apt-get install -y software-properties-common curl wget gnupg2 lsb-release

# 2. Install Python 3.11 & Pip
echo "🐍 Installing Python 3.11..."
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt-get update
sudo apt-get install -y python3.11 python3.11-venv python3.11-dev python3.11-distutils
# Manual Pip install (often missing in the PPA)
curl -sS https://bootstrap.pypa.io/get-pip.py | sudo python3.11

# 3. Install PostgreSQL 16
echo "🐘 Installing PostgreSQL 16..."
sudo sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y postgresql-16 postgresql-client-16

# 4. Start Postgres and Create User
echo "⚙️ Configuring Database..."
sudo service postgresql start
# Create a superuser role for the 'vscode' user so you can psql without 'sudo'
sudo -u postgres psql -c "CREATE ROLE vscode WITH SUPERUSER LOGIN;" || true

# 5. Verification
echo "✅ Verification:"
python3.11 --version
psql --version
sudo service postgresql status

echo "🎉 Setup Complete! You are now logged in as $(whoami)."