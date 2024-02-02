# Configuring Static VXLAN

This guide explains how to set up a VXLAN connection between two hosts, each linked to a router. The setup involves configuring static or multicast VXLAN connections.

## Initial Setup

Both routers are connected on `eth0` with the switch, and `eth1` with the hosts.

### Step 1: Set IP Addresses

Assign IP addresses to the router interfaces.

```bash
ip addr add 10.1.1.1/24 dev eth0
```

To verify the IP address configuration on `eth0`, use:

```bash
ip addr show eth0
```

### Step 2: Configure VXLAN

Depending on the requirement, configure VXLAN as either static or multicast.

- **Static VXLAN Configuration:**

  ```bash
  ip link add name vxlan10 type vxlan id 10 dev eth0 local 10.1.1.1 remote 10.1.1.2 dstport 4789
  ```

- **Multicast VXLAN Configuration:**

  ```bash
  ip link add name vxlan10 type vxlan id 10 dev eth0 group 239.1.1.1 dstport 4789
  ```

### Step 3: Create a Bridge on the Router

```bash
ip link add br0 type bridge
```

### Step 4: Activate VXLAN Device

Bring up the VXLAN device.

```bash
ip link set dev vxlan10 up
```

To check the VXLAN configuration, use:

```bash
ip link show vxlan10
```

### Step 5: Setup and Boot Up Bridge

Activate the bridge interface.

```bash
ip link set dev br0 up
```

### Step 6: Add Interfaces to the Bridge

Add both `eth1` and `vxlan10` to the bridge `br0`.

```bash
brctl addif br0 eth1
brctl addif br0 vxlan10
```

To verify that `vxlan10` and `eth1` are part of the bridge `br0`, execute:

```bash
ip link show vxlan10
ip link show eth1
```

## Configuring Hosts

Assign IP addresses to hosts connected to `eth1`.

```bash
ip addr add 30.1.1.1/24 dev eth1
```

You can now test the connectivity by pinging from one host to another, for example:

```bash
ping 30.1.1.1
```

## Verifying Multicast Group Functionality

To demonstrate that the multicast group is operational, change one router's multicast group, restart, and apply the new configuration. If the multicast group is not matching on both routers, the ping will not work, indicating the importance of consistent multicast group configuration for VXLAN connectivity.
