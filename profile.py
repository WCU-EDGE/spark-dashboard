import geni.portal as portal
import geni.rspec.pg as pg
import geni.rspec.igext as IG
from lxml import etree as ET

pc = portal.Context()
request = pc.makeRequestRSpec()

pc.defineParameter("sparkCount", "Number of Spark compute nodes",
                   portal.ParameterType.INTEGER, 4)


pc.defineParameter("serverCount", "Number of honey pot webservers",
                   portal.ParameterType.INTEGER, 1)

pc.defineParameter("notebookPass","The Jupyter notebook password",
                   portal.ParameterType.STRING,"",
                   longDescription="You should choose a unique password at least 8 characters long.")

class EmulabEncrypt(pg.Resource):
    def _write(self, root):
        #ns = "{http://www.protogeni.net/resources/rspec/ext/emulab/1}"
        ns = "{http://www.protogeni.net/resources/rspec/ext/johnsond/1}"
        
        el = ET.SubElement(root,"%spassword" % (ns,),attrib={'name':'notebookPass'})
        pass
    pass

params = pc.bindParameters()
pc.verifyParameters()

tourDescription = \
"""
This profile provides the template for a small cluster to implement/test Spark Streaming Dashboard
"""


tourInstructions = \
"""
[Grafana Server WebUI](http://{host-grafana}:8080/) 

[Spark Cluster WebUI](http://{host-head}:8080/)

[Jupyter Notebook Server](http://{host-head}:8888/)

"""


#
# Setup the Tour info with the above description and instructions.
#  

tour = IG.Tour()
tour.Description(IG.Tour.TEXT,tourDescription)
tour.Instructions(IG.Tour.MARKDOWN, tourInstructions)

request.addTour(tour)

prefixForIP = "192.168.1."
currentIP = 1
link = request.LAN("lan")


# setup Spark cluster
for i in range(params.sparkCount):
  if i == 0:
    node = request.XenVM("head")
    node.routable_control_ip = "true"
    bs = node.Blockstore("bs" + str(i), "/opt")
    bs.size = "100GB"
  else:
    node = request.XenVM("worker-" + str(i))
  node.cores = 4
  node.ram = 8192
  node.disk_image = "urn:publicid:IDN+emulab.net+image+emulab-ops:UBUNTU18-64-STD"
  iface = node.addInterface("if" + str(currentIP))
  iface.component_id = "eth1"
  iface.addAddress(pg.IPv4Address(prefixForIP + str(currentIP), "255.255.255.0"))
  currentIP = currentIP + 1
  link.addInterface(iface)
  node.addService(pg.Execute(shell="sh", command="sudo bash /local/repository/setup_user.sh " + str(params.notebookPass)))
  if i == 0:
    node.addService(pg.Execute(shell="sh", command="sudo bash /local/repository/setup_spark_master.sh " + str(params.sparkCount) + " " + str(params.notebookPass)))
  else:
    node.addService(pg.Execute(shell="sh", command="sudo bash /local/repository/setup_spark_workers.sh"))
 

# setup broker
node = request.XenVM("broker")
node.cores = 2
node.ram = 2048
node.routable_control_ip = "true" 
node.disk_image = "urn:publicid:IDN+emulab.net+image+emulab-ops:UBUNTU18-64-STD"
iface = node.addInterface("if" + str(currentIP))
iface.component_id = "eth1"
iface.addAddress(pg.IPv4Address(prefixForIP + str(currentIP), "255.255.255.0"))
link.addInterface(iface)
node.addService(pg.Execute(shell="sh", command="sudo bash /local/repository/setup_broker.sh"))
currentIP = currentIP + 1

    
# setup three webservers
for i in range(params.serverCount):
  node = request.XenVM("ws" + str(i+1))
  node.routable_control_ip = "true" 
  node.disk_image = "urn:publicid:IDN+emulab.net+image+emulab-ops:UBUNTU18-64-STD"
  iface = node.addInterface("if" + str(currentIP))
  iface.component_id = "eth1"
  iface.addAddress(pg.IPv4Address(prefixForIP + str(currentIP), "255.255.255.0"))
  link.addInterface(iface)
  node.addService(pg.Execute(shell="sh", command="sudo bash /local/repository/setup_webserver.sh "))
  currentIP = currentIP + 1

  
# setup grafana
node = request.XenVM("grafana")
node.cores = 2
node.ram = 2048
node.routable_control_ip = "true" 
node.disk_image = "urn:publicid:IDN+emulab.net+image+emulab-ops:UBUNTU18-64-STD"
iface = node.addInterface("if" + str(currentIP))
iface.component_id = "eth1"
iface.addAddress(pg.IPv4Address(prefixForIP + str(currentIP), "255.255.255.0"))
link.addInterface(iface)
node.addService(pg.Execute(shell="sh", command="sudo bash /local/repository/setup_grafana.sh pc.notebookPass"))
currentIP = currentIP + 1

if True:
    stuffToEncrypt = EmulabEncrypt()
    request.addResource(stuffToEncrypt)
    pass
 
pc.printRequestRSpec(request)
