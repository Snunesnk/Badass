ip addr add 10.1.1.2/24 dev eth0
## Static VXLAN
# ip link add name vxlan10 type vxlan id 10 dev eth0 local 10.1.1.2 remote 10.1.1.1 dstport 4789
## Dynamic VXLAN
ip link add name vxlan10 type vxlan id 10 dev eth0 group 239.1.1.1 dstport 4789
ip link set dev vxlan10 up
ip link add br0 type bridge
ip link set dev br0 up
brctl addif br0 eth1
brctl addif br0 vxlan10
