import geni.portal as portal
import geni.rspec.pg as RSpec
import geni.rspec.igext

pc = portal.Context()

pc.defineParameter( "n", "Number of nodes",
		    portal.ParameterType.INTEGER, 3 )

pc.defineParameter( "raw", "Use physical nodes",
                    portal.ParameterType.BOOLEAN, False )

pc.defineParameter( "mem", "Memory per VM",
		    portal.ParameterType.INTEGER, 64 )

params = pc.bindParameters()

def Node(name, public):
    if params.raw:
        return RSpec.RawPC( name )
    else:
        vm = geni.rspec.igext.XenVM( name )
        vm.ram = params.mem
        if public:
            vm.routable_control_ip = True
        return vm

rspec = RSpec.Request()

lan = RSpec.LAN()
rspec.addResource( lan )
prefixForIP="192.168.1."

for i in range(params.n):
  if i == 0:
    node = Node("namenode", True)
    node.addService(RSpec.Execute(shell="sh", command="sudo bash /local/repository/nfs/nfs-server.sh " + str(params.n)))
    node.addService(RSpec.Execute(shell="sh", command="sudo bash /local/repository/hadoop/namenode.sh"))
  else:
    node = Node("datanode-" + str(i), False)
    node.addService(RSpec.Execute(shell="sh", command="sudo bash /local/repository/nfs/nfs-client.sh"))
    node.addService(RSpec.Execute(shell="sh", command="sudo bash /local/repository/hadoop/datanode.sh"))
  bs = node.Blockstore("bs" + str(i), "/hadoop")
  bs.size = "500GB"
  node.disk_image = "urn:publicid:IDN+emulab.net+image+emulab-ops:CENTOS7-64-STD"
  iface = node.addInterface("if" + str(i))
  iface.component_id = "eth1"
  iface.addAddress(RSpec.IPv4Address(prefixForIP + str(i + 1), "255.255.255.0"))
  lan.addInterface(iface)
  rspec.addResource( node )

from lxml import etree as ET
tour = geni.rspec.igext.Tour()
tour.Description( geni.rspec.igext.Tour.TEXT, "A cluster running Hadoop 2.7.3. It includes a name node, a resource manager, and as many workers as you choose." )
tour.Instructions( geni.rspec.igext.Tour.MARKDOWN, "After your instance boots (approx. 5-10 minutes), you can log into the resource manager node and submit jobs.  [The HDFS web UI](http://{host-namenode}:9870/) and [the resource manager UI](http://{host-namenode}:8088/) will also become available." )
rspec.addTour( tour )

pc.printRequestRSpec( rspec )
