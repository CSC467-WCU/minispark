import geni.portal as portal
import geni.rspec.pg as pg
import geni.rspec.igext as IG

pc = portal.Context()
request = pc.makeRequestRSpec()

tourDescription = \
"""
This profile provides the template for a compute node with on Ubuntu 18.04
"""

#
# Setup the Tour info with the above description and instructions.
#  
tour = IG.Tour()
tour.Description(IG.Tour.TEXT,tourDescription)
request.addTour(tour)

node = request.XenVM("spark-node")
node.cores = 8
node.ram = 8192
node.routable_control_ip = "true" 
node.disk_image = "urn:publicid:IDN+emulab.net+image+emulab-ops:UBUNTU18-64-STD"

node.addService(pg.Execute(shell="sh", command="sudo bash /local/repository/install_spark.sh"))
  
pc.printRequestRSpec(request)
