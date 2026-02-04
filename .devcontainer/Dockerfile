FROM python:3.12-slim

# 1. Install system tools and generic PostgreSQL
# We use 'postgresql' (no version number) to let apt pick the OS default.
RUN apt-get update && apt-get install -y \
    git \
    curl \
    sudo \
    postgresql \
    postgresql-contrib \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# 2. Setup the 'vscode' user with sudo access
RUN useradd -m -s /bin/bash vscode \
    && echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# 3. Switch context to the user
USER vscode
WORKDIR /workspaces/my-data-project

# 4. Install Python dependencies
# We copy from '..' (root) because of the context setting in devcontainer.json
COPY --chown=vscode:vscode requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 5. Keep the container alive (Do nothing else)
CMD ["sleep", "infinity"]
