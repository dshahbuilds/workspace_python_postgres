FROM python:3.12-slim

# 1. Install system tools and PostgreSQL
RUN apt-get update && apt-get install -y \
    git \
    curl \
    postgresql \
    postgresql-contrib \
    libpq-dev \
    gcc \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# 2. Configure a non-root user 'vscode' (standard for DevContainers)
RUN useradd -m -s /bin/bash vscode \
    && echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# 3. Setup PostgreSQL data directory permission
# We allow the 'vscode' user to own the postgres data so they can start the server
RUN chown -R vscode:vscode /var/lib/postgresql \
    && chown -R vscode:vscode /var/run/postgresql

# 4. Switch to the user to install Python packages
USER vscode
WORKDIR /workspaces/my-data-project

# 5. Copy and install Python requirements
COPY --chown=vscode:vscode requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 6. Initialize the Database (This runs once during build)
# We create a new cluster specifically for the 'vscode' user
RUN /usr/lib/postgresql/16/bin/initdb -D /home/vscode/pgdata

# 7. Configure Postgres to listen on local connections
RUN echo "host all all 127.0.0.1/32 trust" >> /home/vscode/pgdata/pg_hba.conf

# 8. Define the startup command
# This starts Postgres in the background, creates your DB, and then keeps the container running
CMD /usr/lib/postgresql/16/bin/pg_ctl -D /home/vscode/pgdata -l /home/vscode/logfile start \
    && createdb data_eng_db \
    && echo "✅ Database Started & Ready!" \
    && sleep infinity
