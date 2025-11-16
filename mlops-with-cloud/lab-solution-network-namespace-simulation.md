# Network Namespace Simulation - Complete Solution

## Overview

This solution implements a network simulation with two separate networks connected via a router using Linux network namespaces and bridges.

## Quick Start

### Prerequisites
- Linux system with root access
- `iproute2` package installed
- `make` utility installed

### Setup and Test

```bash
# Make the script executable
chmod +x network-namespace-setup.sh

# Option 1: Using Makefile (recommended)
sudo make setup    # Create the network simulation
sudo make verify   # Verify configuration
sudo make ping     # Test connectivity
sudo make cleanup  # Clean up when done

# Option 2: Using bash script directly
sudo ./network-namespace-setup.sh setup
sudo ./network-namespace-setup.sh verify
sudo ./network-namespace-setup.sh test
sudo ./network-namespace-setup.sh cleanup

# Option 3: Run everything at once
sudo make all
```

## IP Addressing Scheme

### Network 1 (10.0.1.0/24)
- **Subnet**: 10.0.1.0/24
- **ns1**: 10.0.1.10/24
- **router-ns (br0 interface)**: 10.0.1.254/24
- **Purpose**: First isolated network segment

### Network 2 (10.0.2.0/24)
- **Subnet**: 10.0.2.0/24
- **ns2**: 10.0.2.10/24
- **router-ns (br1 interface)**: 10.0.2.254/24
- **Purpose**: Second isolated network segment

### Design Rationale
- Used /24 subnets (254 usable hosts) for flexibility
- Router uses .254 as gateway (common convention)
- Client namespaces use .10 (easy to remember)
- Private IP ranges (RFC 1918 compliant)

## Routing Configuration

### ns1 Routing Table
```
default via 10.0.1.254 dev veth-ns1
10.0.1.0/24 dev veth-ns1 proto kernel scope link src 10.0.1.10
```
- Default route points to router-ns (10.0.1.254)
- All non-local traffic goes through the router

### ns2 Routing Table
```
default via 10.0.2.254 dev veth-ns2
10.0.2.0/24 dev veth-ns2 proto kernel scope link src 10.0.2.10
```
- Default route points to router-ns (10.0.2.254)
- All non-local traffic goes through the router

### router-ns Configuration
```
10.0.1.0/24 dev veth-r-br0 proto kernel scope link src 10.0.1.254
10.0.2.0/24 dev veth-r-br1 proto kernel scope link src 10.0.2.254
```
- IP forwarding enabled: `net.ipv4.ip_forward=1`
- Connected to both networks
- Routes packets between 10.0.1.0/24 and 10.0.2.0/24

## Network Components

### Bridges
1. **br0**: Virtual switch for network 1
   - Connects ns1 and router-ns on the 10.0.1.0/24 network
   
2. **br1**: Virtual switch for network 2
   - Connects ns2 and router-ns on the 10.0.2.0/24 network

### Network Namespaces
1. **ns1**: Client namespace in network 1
2. **ns2**: Client namespace in network 2
3. **router-ns**: Router connecting both networks

### Virtual Ethernet Pairs

| Pair Name | Namespace Side | Bridge Side | Purpose |
|-----------|---------------|-------------|---------|
| veth-ns1 ↔ veth-ns1-br | ns1 | br0 | Connect ns1 to network 1 |
| veth-ns2 ↔ veth-ns2-br | ns2 | br1 | Connect ns2 to network 2 |
| veth-r-br0 ↔ veth-r-br0-br | router-ns | br0 | Connect router to network 1 |
| veth-r-br1 ↔ veth-r-br1-br | router-ns | br1 | Connect router to network 2 |

## Testing Procedures

### 1. Verify Namespace Creation
```bash
sudo ip netns list
```
**Expected output:**
```
router-ns
ns2
ns1
```

### 2. Verify Bridge Creation
```bash
sudo ip link show type bridge
```
**Expected output:**
```
br0: <BROADCAST,MULTICAST,UP,LOWER_UP> ...
br1: <BROADCAST,MULTICAST,UP,LOWER_UP> ...
```

### 3. Test Local Network Connectivity

**Test ns1 to router (same network):**
```bash
sudo ip netns exec ns1 ping -c 3 10.0.1.254
```

**Test ns2 to router (same network):**
```bash
sudo ip netns exec ns2 ping -c 3 10.0.2.254
```

### 4. Test Inter-Network Connectivity

**Test ns1 to ns2 (across networks):**
```bash
sudo ip netns exec ns1 ping -c 3 10.0.2.10
```

**Test ns2 to ns1 (across networks):**
```bash
sudo ip netns exec ns2 ping -c 3 10.0.1.10
```

### 5. Verify IP Forwarding
```bash
sudo ip netns exec router-ns sysctl net.ipv4.ip_forward
```
**Expected output:**
```
net.ipv4.ip_forward = 1
```

### 6. Trace Route Path
```bash
sudo ip netns exec ns1 traceroute -n 10.0.2.10
```
**Expected path:**
```
1  10.0.1.254  (router-ns)
2  10.0.2.10   (ns2)
```

## Test Results

### Successful Test Output Example

```
[INFO] Testing ns1 -> router (10.0.1.254):
PING 10.0.1.254 (10.0.1.254) 56(84) bytes of data.
64 bytes from 10.0.1.254: icmp_seq=1 ttl=64 time=0.045 ms
64 bytes from 10.0.1.254: icmp_seq=2 ttl=64 time=0.038 ms
64 bytes from 10.0.1.254: icmp_seq=3 ttl=64 time=0.041 ms
[INFO] ✓ ns1 can reach router on br0 network

[INFO] Testing ns1 -> ns2 (10.0.2.10) via router:
PING 10.0.2.10 (10.0.2.10) 56(84) bytes of data.
64 bytes from 10.0.2.10: icmp_seq=1 ttl=63 time=0.067 ms
64 bytes from 10.0.2.10: icmp_seq=2 ttl=63 time=0.052 ms
64 bytes from 10.0.2.10: icmp_seq=3 ttl=63 time=0.048 ms
[INFO] ✓ ns1 can reach ns2 through router
```

## Troubleshooting

### Issue: Ping fails between namespaces

**Check 1: Verify IP forwarding**
```bash
sudo ip netns exec router-ns sysctl net.ipv4.ip_forward
```
Should return `1`. If not, enable it:
```bash
sudo ip netns exec router-ns sysctl -w net.ipv4.ip_forward=1
```

**Check 2: Verify routes**
```bash
sudo ip netns exec ns1 ip route
sudo ip netns exec ns2 ip route
```
Both should have default routes pointing to their respective router interfaces.

**Check 3: Verify interfaces are UP**
```bash
sudo ip netns exec ns1 ip link
sudo ip netns exec ns2 ip link
sudo ip netns exec router-ns ip link
```

### Issue: "Cannot find device" error

This usually means a veth pair wasn't created properly. Run cleanup and setup again:
```bash
sudo make cleanup
sudo make setup
```

### Issue: "Operation not permitted"

Ensure you're running commands with `sudo` or as root user.

## Architecture Decisions

### Why Bridges Instead of Direct veth Pairs?
- **Scalability**: Bridges allow multiple namespaces per network
- **Flexibility**: Easy to add more namespaces to each network
- **Real-world simulation**: Bridges simulate actual network switches

### Why Separate Router Namespace?
- **Isolation**: Router logic is isolated from client namespaces
- **Security**: Can implement firewall rules in router namespace
- **Realism**: Mimics actual network architecture

### Why These IP Ranges?
- **RFC 1918 compliance**: Private IP ranges (10.0.0.0/8)
- **Non-overlapping**: Clear separation between networks
- **Standard conventions**: .254 for gateway, .10 for clients

## Files Included

1. **network-namespace-setup.sh**: Main automation script
   - Setup, verify, test, and cleanup functions
   - Color-coded output for better readability
   - Error handling and validation

2. **Makefile**: Convenient make targets
   - `make setup`: Create network simulation
   - `make verify`: Check configuration
   - `make ping`: Test connectivity
   - `make cleanup`: Remove all resources
   - `make all`: Run full workflow

3. **network-topology.md**: Visual documentation
   - Mermaid diagrams showing network topology
   - Traffic flow visualization
   - Component details

4. **lab-solution-network-namespace-simulation.md**: This document
   - Complete documentation
   - Testing procedures
   - Troubleshooting guide

## Learning Outcomes

By completing this lab, you have learned:

1. **Network Namespaces**: How to create isolated network environments
2. **Virtual Ethernet Pairs**: Connecting namespaces and bridges
3. **Linux Bridges**: Creating virtual network switches
4. **IP Routing**: Configuring routes and enabling IP forwarding
5. **Network Testing**: Using ping and traceroute for verification
6. **Automation**: Writing bash scripts and Makefiles for infrastructure

## Advanced Exercises

### 1. Add a Third Network
Create a third network (10.0.3.0/24) with ns3 and connect it through the router.

### 2. Implement Firewall Rules
Use `iptables` in router-ns to:
- Block traffic from ns1 to ns2
- Allow only ICMP traffic
- Implement NAT

### 3. Add DNS Resolution
Set up a simple DNS server in one namespace and configure others to use it.

### 4. Monitor Traffic
Use `tcpdump` to capture and analyze traffic flowing through the router.

### 5. Simulate Network Latency
Use `tc` (traffic control) to add latency between networks.

## References

- [Linux Network Namespaces Documentation](https://man7.org/linux/man-pages/man8/ip-netns.8.html)
- [iproute2 Documentation](https://wiki.linuxfoundation.org/networking/iproute2)
- [Linux Bridge Documentation](https://wiki.linuxfoundation.org/networking/bridge)
- [Virtual Ethernet Devices](https://man7.org/linux/man-pages/man4/veth.4.html)
