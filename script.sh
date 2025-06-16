#!/bin/bash

# ----------------------------
# Moodle Docker Setup Script (Ubuntu)
# ----------------------------

# ---- VARIABLES ----
export MOODLE_VERSION="MOODLE_405_STABLE"
export INSTALL_DIR="/home/ubuntu/AJA-Moodle-LMS"
export BACKUP_DIR="$INSTALL_DIR/backups"
export MOODLEDATA_HOST_DIR="$INSTALL_DIR/moodledata"
export PORT="8080"
export PUBLIC_IP="54.152.229.226"
THEME_ZIP="/home/ubuntu/theme_academi_moodle50_2025050301.zip"

# ---- STEP 1: Install Docker and Git ----
echo "=== 1. Installing Docker and Git ==="
sudo apt update -y
sudo apt install -y docker.io git unzip curl

sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER

# ---- STEP 2: Install Docker Compose (v2) ----
echo "=== 2. Installing Docker Compose ==="
sudo curl -SL https://github.com/docker/compose/releases/download/v2.27.1/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# ---- STEP 3: Moodle Directory Setup ----
echo "=== 3. Setting up Moodle folder structure ==="
mkdir -p "$INSTALL_DIR" && cd "$INSTALL_DIR"

mkdir -p moodledata backups
sudo mkdir -p $MOODLEDATA_HOST_DIR
sudo chown -R 33:33 $MOODLEDATA_HOST_DIR
sudo chmod -R 755 $MOODLEDATA_HOST_DIR

#sudo chown -R 33:33 /home/ubuntu/AJA-Moodle-LMS/moodledata
#sudo chmod -R 755 /home/ubuntu/AJA-Moodle-LMS/moodledata





chmod +x backup.sh

# ---- STEP 9: Setup Cron ----
echo "=== 9. Adding cron job for daily backups ==="
(crontab -l 2>/dev/null; echo "0 2 * * * $INSTALL_DIR/backup.sh >> $INSTALL_DIR/backup.log 2>&1") | crontab -

# ---- STEP 10: Docker Compose Up ----
echo "=== 10. Launching Moodle with Docker Compose ==="
cd "$INSTALL_DIR"
sudo docker-compose down
sudo docker-compose up -d --build   

# ---- STEP 12: Fix config.php permissions ----
echo "=== 12. Fixing permissions for config.php inside container ==="
sudo docker exec moodle-app chown www-data:www-data /var/www/html/config.php
sudo docker exec moodle-app chmod 644 /var/www/html/config.php

# ---- STEP 13: Restart containers ----
echo "=== 13. Restarting Docker containers ==="
cd "$INSTALL_DIR"
sudo docker-compose restart
# ---- DONE ----
echo ""
echo "=== ✅ Moodle Setup Complete with config.php and Klass theme ==="
echo "🌐 Access Moodle at: http://$PUBLIC_IP:$PORT"
echo "🕓 Daily backups scheduled at 2:00 AM in: $BACKUP_DIR"
echo "🔁 If you still get 'permission denied', try: newgrp docker or reboot the server"
