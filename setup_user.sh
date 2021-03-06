#!/bin/bash

apt-get update
apt-get install -qqq -y python3 python3-pip python3-numpy python3-matplotlib python3-scipy python3-pandas python3-simpy ipython3
pip3 install tweepy feedparser jupyter ipykernel findspark
pip3 install --upgrade Pygments
pip3 install --upgrade ipython
pip3 install kafka-python
pip3 install influxdb
update-alternatives --install "/usr/bin/python" "python" "$(which python3)" 1

echo "Password: " $1
mypass=$(python3 -c "import crypt; print(crypt.crypt('$1', crypt.mksalt(crypt.METHOD_SHA512)))")
useradd -m -p $mypass -s /bin/bash rammy
