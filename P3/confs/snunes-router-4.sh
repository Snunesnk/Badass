vtysh << EOF
conf t
hostname frr-4
! Turn off IPv6 forwarding
no ipv6 forwarding
! Set the IP addres on eth0 interface
interface eth0
 ip address 10.1.1.1/30
exit
! Set the IP addres on eth1 interface
interface eth1
 ip address 10.1.1.5/30
exit
! Set the IP addres on eth2 interface
interface eth2
 ip address 10.1.1.9/30
exit
! Set the IP addres on lo interface
interface lo
 ip address 1.1.1.1/32
! Enable a routing process BGP with AS number 1
router bgp 1
 ! Create a BGP peer-group tagged DYNAMIC
 neighbor ibgp peer-group
 ! Assign the peer group to AS number 1
 neighbor ibgp remote-as 1
 ! Communicate with a neighbor through lo interface
 neighbor ibgp update-source lo
 ! Configure BGP dynamic neighbors listen on specified TRUSTED range and add then to specified peer group
 bgp listen range 1.1.1.0/29 peer-group ibgp
 ! Configure a neighbor in peer group DYNAMIC as Route Reflector client
 address-family l2vpn evpn
  neighbor ibgp activate
  neighbor ibgp route-reflector-client
 exit-address-family
! Enable routing process OSPF on all IP networks on area 0
router ospf
 network 0.0.0.0/0 area 0
exit
EOF