#!/usr/bin/env bash
set -euo pipefail

sudo dnf update -y
sudo dnf install -y python3

if ! id -u webuser >/dev/null 2>&1; then
    sudo useradd -r -s /sbin/nologin webuser
fi

sudo mkdir -p /var/www/lab2app
echo "<h1>ACS730 Lab 2 Web App - Active and Survives Reboot</h1>" | sudo tee /var/www/lab2app/index.html > /dev/null

sudo chown -R webuser:webuser /var/www/lab2app
sudo chmod -R 755 /var/www/lab2app

if [ -f acs730-web.service ]; then
    sudo cp acs730-web.service /etc/systemd/system/acs730-web.service
    sudo chmod 644 /etc/systemd/system/acs730-web.service
fi

sudo systemctl daemon-reload
sudo systemctl enable acs730-web.service
sudo systemctl start acs730-web.service
