FROM selenium/standalone-chrome-debug

USER root

# Install MySQL Server
RUN apt-get update && \
    apt-get install -y mysql-server && \
    rm -rf /var/lib/apt/lists/*

# Set the root password to 'root'
RUN service mysql start && mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root'; FLUSH PRIVILEGES;"

# Create a database named 'sync_notion'
RUN service mysql start && mysql -u root -proot -e "CREATE DATABASE sync_notion;"

# Install required Python packages
RUN apt-get update && \
    apt-get install -y python3-pip && \
    pip install --upgrade google-api-python-client google-auth google-auth-oauthlib google-auth-httplib2 bs4 emoji notion tqdm gspread oauth2client selenium pytz

COPY . /app
WORKDIR /app

CMD ["python3", "main.py"]
