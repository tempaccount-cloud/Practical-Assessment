#!/bin/bash
set -euxo pipefail

sudo apt-get update -y 
sudo apt-get install -y apache2

sudo a2enmod ssl
sudo systemctl restart apache2
sudo mkdir -p /etc/apache2/ssl
sudo echo "<h1>Secure Apache Web Server</h1>" | sudo tee /var/www/html/index.html > /dev/null

sudo cp /tmp/server.crt /etc/apache2/ssl/
sudo cp /tmp/server.key /etc/apache2/ssl/
sudo cp /tmp/rootCA.crt /etc/apache2/ssl/

cat <<EOF | sudo tee /etc/apache2/sites-available/default-ssl.conf > /dev/null
<IfModule mod_ssl.c>
  <VirtualHost _default_:443>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html

    SSLEngine on
    SSLCertificateFile /etc/apache2/ssl/server.crt
    SSLCertificateKeyFile /etc/apache2/ssl/server.key
    SSLCACertificateFile /etc/apache2/ssl/rootCA.crt

    SSLVerifyClient require
    SSLVerifyDepth 1

    <Location />
      Require all granted
    </Location>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined

    SSLProtocol all -SSLv2 -SSLv3 -TLSv1 -TLSv1.1
    SSLCipherSuite HIGH:!aNULL:!MD5:!3DES
    SSLHonorCipherOrder on
    SSLCompression off
  </VirtualHost>
</IfModule>
EOF

sudo a2ensite default-ssl
sudo systemctl reload apache2

sudo iptables -F

sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT

sudo iptables -A INPUT -i lo -j ACCEPT

sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

sudo iptables -P INPUT DROP


sudo iptables-save | sudo tee /etc/iptables.rules > /dev/null

cat <<EOF | sudo tee /etc/network/if-pre-up.d/iptables > /dev/null
#!/bin/sh
iptables-restore < /etc/iptables.rules
EOF

sudo chmod +x /etc/network/if-pre-up.d/iptables

echo "127.0.0.1 mytest-web.com" | sudo tee -a /etc/hosts

curl -k https://mytest-web.com
curl -k --cert client.crt --key client.key https://mytest-web.com