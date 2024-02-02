# Part 3: Discovering BGP with EVPN

## Configurations

name             | interface  | ip address | mask
-----------------|------------|------------|--------------------
snunes-host-1    | eth1       | 20.1.1.1   | 255.255.255.0 (24)
snunes-host-2    | eth0       | 20.1.1.2   | 255.255.255.0 (24)
snunes-host-3    | eth0       | 20.1.1.3   | 255.255.255.0 (24)

### host 1
```
ip addr add 20.1.1.1/24 dev eth1
```

### host 2
```
ip addr add 20.1.1.2/24 dev eth0
```

### host 3
```
ip addr add 20.1.1.3/24 dev eth0
```

### routeur 1
*name: snunes-router-1*

interface | ip address | mask 
----------|------------|----------------------
eth0      | 10.1.1.2   | 255.255.255.252 (30)
lo        | 1.1.1.2    | 255.255.255.255 (32)

- setup vxlan / bridge
```
ip link add vxlan10 type vxlan id 10 dstport 4789
ip link set dev vxlan10 up
ip link add name br0 type bridge
ip link set dev br0 up
brctl addif br0 eth1
brctl addif br0 vxlan10
```

- setup daemons
```
vtysh
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
```


### routeur 2
*name: snunes-router-2*

interface | ip address | mask 
----------|------------|----------------------
eth1      | 10.1.1.6   | 255.255.255.252 (30)
lo        | 1.1.1.3    | 255.255.255.255 (32)

- setup vxlan / bridge
```
ip link add vxlan10 type vxlan id 10 dstport 4789
ip link set dev vxlan10 up
ip link add name br0 type bridge
ip link set dev br0 up
brctl addif br0 eth0
brctl addif br0 vxlan10
```

```
vtysh
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
```

### routeur 3
*name: snunes-router-3*

interface | ip address | mask 
----------|------------|----------------------
eth2      | 10.1.1.10  | 255.255.255.252 (30)
lo        | 1.1.1.4    | 255.255.255.255 (32)

- setup vxlan / bridge
```
ip link add name vxlan10 type vxlan id 10 dev eth1 dstport 4789
ip link set dev vxlan10 up
ip link add name br0 type bridge
ip link set dev br0 up
brctl addif br0 eth0
brctl addif br0 vxlan10
```

```
vtysh
conf t
! Turn off IPv6 forwarding
no ipv6 forwarding
! Set the IP addres and enable OSPF on eth1 interface
interface eth2
 ip address 10.1.1.10/30
 ip ospf area 0
exit
! Set the IP addres and enable OSPF on lo interface
interface lo
 ip address 1.1.1.4/32
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
  advertise-all-vni
 exit-address-family
! Enable a routing process OSPF
router ospf
```

### routeur 4  (RR)
*name: snunes-router-4*

interface | ip address | mask 
----------|------------|----------------------
eth0      | 10.1.1.1   | 255.255.255.252 (30)
eth1      | 10.1.1.5   | 255.255.255.252 (30)
eth2      | 10.1.1.9   | 255.255.255.252 (30)
lo        | 1.1.1.1    | 255.255.255.255 (32)

```
vtysh
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
```

### Some usefull commands:
- `do sh ip rout` => Affiche les routes pour une ip
- `do sh bgp summary` => Affiche le sommaire bgp
- `do sh bgp l2vpm evp` => Affiche le type de route, et la donnée associée. Type 2 => Adresse mac, type 3: Adresse ip
- `ifonfig eth1` => Confirm host address mac received by router
We can check that all routers have discovered newly booted up host
Check les adresses mac et le vxlan sur wireshark
Check OSPF packets trough wireshark by filtering by OSPF
