ip link add vxlan10 type vxlan id 10 dev eth0 dstport 4789
ip link set dev vxlan10 up
ip link add name br0 type bridge
ip link set dev br0 up
brctl addif br0 eth1
brctl addif br0 vxlan10

vtysh << EOF
conf t
hostname frrr-1
no ipv6 forwarding
! Set the IP addres and enable OSPF
interface eth0
 ip address 10.1.1.2/30
 ip ospf area 0
! Set the IP addres and enable OSPF on lo interface
interface lo
 ip address 1.1.1.2/32
 ip ospf area 0
! Enable a routing process BGP with AS number 1
router bgp 1
 ! Specify a BGP neighbor with AS number 1
 neighbor 1.1.1.1 remote-as 1
 ! Communicate with a neighbor through lo interface
 neighbor 1.1.1.1 update-source lo
 ! Enable the Address Family for neighbor 1.1.1.1 and advertise all local VNIs
 address-family l2vpn evpn
  neighbor 1.1.1.1 activate
  advertise-all-vni
 exit-address-family
! Enable a routing process OSPF
router ospf
EOF