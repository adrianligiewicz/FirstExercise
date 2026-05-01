#!/bin/bash

#Update system and install nginx
sudo apt update && sudo apt upgrade -y
sudo apt install -y nginx

#Find nginx root directory and move index.html there
find_nginx_root() {
    local config=$(nginx -t 2>&1 | grep -m1 -o '/[^ ]*nginx.conf')
    local include_line=$(grep -E 'include.*sites-enabled' "$config")
    local sites_enabled=$(echo "$include_line" | awk '{print $2}' | tr -d ';')
    local sites_enabled_dir=$(dirname "$sites_enabled")
    local default_file="$sites_enabled_dir/default"
    local root_line=$(grep -E '^[^#]*root' "$default_file")
    local root_path=$(echo "$root_line" | awk '{print $2}' | tr -d ';')
    echo "$root_path"
}

sudo mv "$(dirname "$0")/index.html" "$(find_nginx_root)"

# Check, install and configure UFW if not present
if ! command -v ufw &> /dev/null; then
    sudo apt install -y ufw
fi

sudo ufw allow 'Nginx HTTP'
sudo ufw allow 'ssh'
sudo ufw --force-enable

#Start nginx
sudo systemctl start nginx