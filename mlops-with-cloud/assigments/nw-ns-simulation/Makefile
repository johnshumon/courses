# Makefile for network namespace simulation
.PHONY: setup verify ping clean help

help:
	@echo "Network Namespace Simulation - Available targets:"
	@echo "  make setup   - Create and configure network topology"
	@echo "  make verify  - Verify network configuration"
	@echo "  make ping    - Test connectivity between namespaces"
	@echo "  make clean   - Remove all network namespaces and bridges"

setup:
	@echo "==> Setting up network namespaces and bridges..."
	@sudo apt update && sudo apt upgrade -y
	@sudo apt install -y iproute2 net-tools
	@sudo sysctl -w net.ipv4.ip_forward=1
	@echo "Creating namespaces..."
	@sudo ip netns add ns1 2>/dev/null || true
	@sudo ip netns add ns2 2>/dev/null || true
	@sudo ip netns add router-ns 2>/dev/null || true
	@echo "Creating bridges..."
	@sudo ip link add br0 type bridge 2>/dev/null || true
	@sudo ip link add br1 type bridge 2>/dev/null || true
	@sudo ip link set br0 up
	@sudo ip link set br1 up
	@echo "Creating veth pairs..."
	@sudo ip link add v-ns1 type veth peer name v-ns1-br0 2>/dev/null || true
	@sudo ip link add v-rns1 type veth peer name v-rns1-br0 2>/dev/null || true
	@sudo ip link add v-ns2 type veth peer name v-ns2-br1 2>/dev/null || true
	@sudo ip link add v-rns2 type veth peer name v-rns2-br1 2>/dev/null || true
	@echo "Moving interfaces to namespaces..."
	@sudo ip link set v-ns1 netns ns1
	@sudo ip link set v-ns2 netns ns2
	@sudo ip link set v-rns1 netns router-ns
	@sudo ip link set v-rns2 netns router-ns
	@echo "Attaching veth pairs to bridges..."
	@sudo ip link set v-ns1-br0 master br0
	@sudo ip link set v-rns1-br0 master br0
	@sudo ip link set v-ns2-br1 master br1
	@sudo ip link set v-rns2-br1 master br1
	@echo "Bringing up interfaces in root namespace..."
	@sudo ip link set v-ns1-br0 up
	@sudo ip link set v-rns1-br0 up
	@sudo ip link set v-ns2-br1 up
	@sudo ip link set v-rns2-br1 up
	@echo "Configuring IPs in namespaces..."
	@sudo ip netns exec ns1 ip addr add 192.168.10.2/24 dev v-ns1
	@sudo ip netns exec ns1 ip link set v-ns1 up
	@sudo ip netns exec ns1 ip link set lo up
	@sudo ip netns exec ns1 ip route add default via 192.168.10.1
	@sudo ip netns exec ns2 ip addr add 192.168.20.2/24 dev v-ns2
	@sudo ip netns exec ns2 ip link set v-ns2 up
	@sudo ip netns exec ns2 ip link set lo up
	@sudo ip netns exec ns2 ip route add default via 192.168.20.1
	@sudo ip netns exec router-ns ip addr add 192.168.10.1/24 dev v-rns1
	@sudo ip netns exec router-ns ip addr add 192.168.20.1/24 dev v-rns2
	@sudo ip netns exec router-ns ip link set v-rns1 up
	@sudo ip netns exec router-ns ip link set v-rns2 up
	@sudo ip netns exec router-ns ip link set lo up
	@sudo ip netns exec router-ns sysctl -w net.ipv4.ip_forward=1
	@echo "Configuring iptables..."
	@sudo iptables -C FORWARD -i br0 -j ACCEPT 2>/dev/null || sudo iptables -A FORWARD -i br0 -j ACCEPT
	@sudo iptables -C FORWARD -i br1 -j ACCEPT 2>/dev/null || sudo iptables -A FORWARD -i br1 -j ACCEPT
	@sudo iptables -C FORWARD -o br0 -j ACCEPT 2>/dev/null || sudo iptables -A FORWARD -o br0 -j ACCEPT
	@sudo iptables -C FORWARD -o br1 -j ACCEPT 2>/dev/null || sudo iptables -A FORWARD -o br1 -j ACCEPT
	@echo "✓ Setup complete"

verify:
	@echo "==> Checking namespace interfaces"
	@echo "ns1 interfaces:"
	@sudo ip netns exec ns1 ip addr show
	@echo ""
	@echo "ns2 interfaces:"
	@sudo ip netns exec ns2 ip addr show
	@echo ""
	@echo "router-ns interfaces:"
	@sudo ip netns exec router-ns ip addr show
	@echo ""
	@echo "==> Checking bridge configurations"
	@echo "Bridge br0:"
	@bridge link show br0
	@echo ""
	@echo "Bridge br1:"
	@bridge link show br1
	@echo ""
	@echo "==> Checking IP forwarding in router namespace"
	@sudo ip netns exec router-ns sysctl net.ipv4.ip_forward
	@echo ""
	@echo "==> Checking ARP tables"
	@echo "Router ARP table:"
	@sudo ip netns exec router-ns ip neigh show

ping:
	@echo "==> Testing connectivity from ns1"
	@echo "  [ns1 -> ROUTER] Pinging router gateway (192.168.10.1)..."
	@sudo ip netns exec ns1 ping -c 3 192.168.10.1
	@echo ""
	@echo "  [ns1 -> ns2] Pinging ns2 (192.168.20.2) via router..."
	@sudo ip netns exec ns1 ping -c 3 192.168.20.2
	@echo ""
	@echo "==> Testing connectivity from ns2"
	@echo "  [ns2 -> ROUTER] Pinging router gateway (192.168.20.1)..."
	@sudo ip netns exec ns2 ping -c 3 192.168.20.1
	@echo ""
	@echo "  [ns2 -> ns1] Pinging ns1 (192.168.10.2) via router..."
	@sudo ip netns exec ns2 ping -c 3 192.168.10.2
	@echo ""
	@echo "✓ All connectivity tests completed"

clean:
	@echo "==> Cleaning up network namespaces and bridges..."
	@sudo ip netns del ns1 2>/dev/null || true
	@sudo ip netns del ns2 2>/dev/null || true
	@sudo ip netns del router-ns 2>/dev/null || true
	@sudo ip link del br0 2>/dev/null || true
	@sudo ip link del br1 2>/dev/null || true
	@sudo iptables -D FORWARD -i br0 -j ACCEPT 2>/dev/null || true
	@sudo iptables -D FORWARD -i br1 -j ACCEPT 2>/dev/null || true
	@sudo iptables -D FORWARD -o br0 -j ACCEPT 2>/dev/null || true
	@sudo iptables -D FORWARD -o br1 -j ACCEPT 2>/dev/null || true
	@echo "✓ Cleanup complete"
