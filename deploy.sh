#!/bin/bash

if [[$EUID -ne 0]] then 
    echo "Ten skrypt wymaga uprawnień roota. Uruchom go jako root"
    exit 1
fi 

apt update -y 

apt install nginx -y 

mkdir -p/var/www/demo-site

cp index.html /var/www/demo-site/index.html

echo "konfiguracja nginx" 
cat <<EOL > /etc/nginx/sites-available/demo-site
server {
    listen 80;
    server_name localhost; 

    root /var/www/demo-site;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOL 

echo "Aktywowanie konfiguracji nginx"
ln -s /etc/nginx/sites-avalilable/demo-site /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

echo "restart nginx"
systemctl restart nginx

echo "Strona została wdrożona! Otwórz przeglądarkę i przejdź do http://localhost lub 127.0.0.1"