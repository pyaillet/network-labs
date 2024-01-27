from diagrams import Cluster, Diagram
from diagrams.generic.network import Switch
from diagrams.generic.network import Router
from diagrams.onprem.compute import Server

with Diagram("VxLan Topology", outformat=["png"], direction = "TB"):
    with Cluster("VXLAN 100"):
        pc1 = Server("pc1\n192.168.32.10")
        pc2 = Server("pc2\n192.168.32.20")
        pc3 = Server("pc3\n192.168.32.30")
        pc7 = Server("pc7\n192.168.32.70")

    with Cluster("VXLAN 101"):
        pc4 = Server("pc4\n192.168.32.40")
        pc5 = Server("pc5\n192.168.32.50")
        pc6 = Server("pc6\n192.168.32.60")

    sw = Switch("sw\n1.1.1.4")
    r1 = Router("r1\n1.1.1.1")
    r2 = Router("r2\n1.1.1.2")
    r3 = Router("r3\n1.1.1.3")
    sw - [r1, r2, r3]
    r1 - [pc1, pc2, pc7]
    r2 - [pc3, pc4]
    r3 - [pc5, pc6]


