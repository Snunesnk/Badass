Les deux routes sont connectes sur eth0 avec le switch, et eth1 avec les hosts.

##Configuring static vxlan:

1. => Create bridge on router: `ip link add br0 type bridge`
2. => Up new interface: `ip link set dev br0 up`
3. => Set ip adresses: `ip addr add 10.1.1.1/24 dev eth0`
   => We can check ip addresses with `ip addr show eth0`
4. => Create vxlan interface: `ip link add name vxlan10 type vxlan id 10 dev eth0 remote 10.1.1.2 local 10.1.1.1 dstport 4789`
5. => Set vxlan up + add ip addr for vxlan: `ip addr add 20.1.1.1/24 dev vxlan10` + `ip link set dev vxlan10 up`
6. => Add bridge between eth1 and vxlan: `brctl addif br0 eth1` + `brctl addif br0 vxlan10`
   => Check vxlan state: `ip link show vxlan10`
   => check eth1 state: `ip link show eth1` => both eth1 et vxlan10 part of bridge br0
7. => repeat for other router
8. => Give ip addresses to hosts: `ip addr add 30.1.1.1/24 dev eth1`

Now we can try to see traffic by intercepting communication between router and switch, and sending `ping 30.1.1.1` from host 30.1.1.2

```
ip link add br0 type bridge
ip link set dev br0 up
ip addr add 10.1.1.1/24 dev eth0
ip link add name vxlan10 type vxlan id 10 dev eth0 remote 10.1.1.2 local 10.1.1.1 dstport 4789
ip addr add 20.1.1.1/24 dev vxlan10
ip link set dev vxlan10 up
brctl addif br0 eth1
brctl addif br0 vxlan10
```

##Configuring for multicast:

1. => reboot servers
2. => Get cmd history to not retype all again: `cat /root/.ash_history`, keep only usefull commands
3. => change vxlan command to: ip link add name vxlan10 type vxlan id 10 dev eth0 group 239.1.1.1 dstport 4789 (no more remote / local)
   => Still adding bridge, ip addresse, bridge control
4. => Do the same for other router
5. => try to ping hosts

To show that group is working, just change group for one router, restart and apply new config. Now ping will not work anymore