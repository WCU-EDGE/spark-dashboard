#This runs on each webserver and funnels the /var/log/auth contents to Kafka broker under topic XYZ
# This is a Kafka producer
from kafka import KafkaProducer
import time
import json

producer = KafkaProducer(bootstrap_servers='broker:9092',value_serializer=lambda v:json.dumps(v).encode('ascii'))

logfile = open('/var/log/auth.log', 'r')
lines = logfile.readlines()

for l in lines:
    producer.send('auth.log',{'ws1':l})

logfile.seek(0,2)

while True:
    line = logfile.readline()
    if not line:
         time.sleep(10)
         continue
    producer.send('auth.log',{'ws1':line})
