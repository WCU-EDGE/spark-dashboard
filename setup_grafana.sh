set -x
sudo apt-get install -y apt-transport-https
sudo apt-get install -y software-properties-common wget
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -

#Adding repository for stable releases 
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

# Install grafana 
sudo apt-get update
sudo apt-get install grafana

# Changing port from default to port 8080
sudo sed -i 's/;http_port = 3000/http_port = 8080/' /etc/grafana/grafana.ini
sudo sed -i "s/;admin_password = admin/admin_password = $1/" /etc/grafana/grafana.ini

# Starting grafana server and enabling start at boot
sudo systemctl daemon-reload
sudo systemctl start grafana-server
sudo systemctl enable grafana-server.service
