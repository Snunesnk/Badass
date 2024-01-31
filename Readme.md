Commandes interessantes:
ip -d link show vxlan10
brctl addif br0 eth1
brctl addif br0 vxlan10

brctl => bridge control
addif => add Interface
vxlan => encapsulation layer 2 / layer 3
VNI => VXLAN Unique Identifier
VXLAN => Virtual Extendended Lan
VTEP => VXLAN Tunneling EndPoint
Unicast => Connexion de server a server, Multicast: Une requete est envoyee au switch qui retransmet a tout le monde pour avoir la reponse
dev => device
