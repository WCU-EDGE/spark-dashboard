set -x
sudo apt-get install -y apt-transport-https
sudo apt-get install -y software-properties-common wget
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -

#Adding repository for stable releases 
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

# Install grafana 
sudo apt-get update
sudo apt-get install grafana

# Install anaconda
apt-get update
apt-get install -qqq -y python3 python3-pip python3-numpy python3-matplotlib python3-scipy python3-pandas python3-simpy ipython3
pip3 install tweepy feedparser jupyter ipykernel findspark
pip3 install --upgrade Pygments
pip3 install --upgrade ipython
update-alternatives --install "/usr/bin/python" "python" "$(which python3)" 1


# Changing port from default to port 8080
sudo sed -i 's/;http_port = 3000/http_port = 8080/' /etc/grafana/grafana.ini

# Change password to Jupyter Notebook password
grafPasswd=$(python3 -c "from notebook.auth import passwd; print(passwd('$1',algorithm='sha1'))")
sudo sed -i "s/;admin_password = admin/admin_password = $grafPasswd/" /etc/grafana/grafana.ini

# Starting grafana server and enabling start at boot
sudo systemctl daemon-reload
sudo systemctl start grafana-server
sudo systemctl enable grafana-server.service
