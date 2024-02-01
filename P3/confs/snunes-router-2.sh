vtysh << EOF
conf t
! Turn off IPv6 forwarding
no ipv6 forwarding
! Set the IP addres and enable OSPF on eth0 interface
interface eth1
 ip address 10.1.1.6/30
 ip ospf area 0
exit
! Set the IP addres and enable OSPF on lo interface
interface lo
 ip address 1.1.1.3/32
 ip ospf area 0
exit
! Enable a routing process BGP with AS number 1
router bgp 1
 ! Specify a BGP neighbor with AS number 1
 neighbor 1.1.1.1 remote-as 1
 ! Communicate with a neighbor through lo interface
 neighbor 1.1.1.1 update-source lo
 ! Enable the Address Family for neighbor 1.1.1.1 and advertise all local VNIs
 address-family l2vpn evpn
  neighbor 1.1.1.1 activate
 exit-address-family
exit
! Enable a routing process OSPF
router ospf
EOF