#!/bin/bash

# Network Namespace Simulation Setup Script
# Creates two separate networks connected via a router namespace

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# IP addressing scheme
BR0_IP="10.0.1.1/24"
BR1_IP="10.0.2.1/24"
NS1_IP="10.0.1.10/24"
NS2_IP="10.0.2.10/24"
ROUTER_BR0_IP="10.0.1.254/24"
ROUTER_BR1_IP="10.0.2.254/24"

# Function to print colored messages
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_error "This script must be run as root"
        exit 1
    fi
}

# Create network bridges
create_bridges() {
    print_info "Creating network bridges..."
    
    # Create br0
    if ! ip link show br0 &>/dev/null; then
        ip link add name br0 type bridge
        ip link set br0 up
        print_info "Bridge br0 created and activated"
    else
        print_warn "Bridge br0 already exists"
    fi
    
    # Create br1
    if ! ip link show br1 &>/dev/null; then
        ip link add name br1 type bridge
        ip link set br1 up
        print_info "Bridge br1 created and activated"
    else
        print_warn "Bridge br1 already exists"
    fi
}

# Create network namespaces
create_namespaces() {
    print_info "Creating network namespaces..."
    
    # Create ns1
    if ! ip netns list | grep -q "^ns1$"; then
        ip netns add ns1
        print_info "Namespace ns1 created"
    else
        print_warn "Namespace ns1 already exists"
    fi
    
    # Create ns2
    if ! ip netns list | grep -q "^ns2$"; then
        ip netns add ns2
        print_info "Namespace ns2 created"
    else
        print_warn "Namespace ns2 already exists"
    fi
    
    # Create router namespace
    if ! ip netns list | grep -q "^router-ns$"; then
        ip netns add router-ns
        print_info "Namespace router-ns created"
    else
        print_warn "Namespace router-ns already exists"
    fi
}

# Create virtual ethernet pairs and connect them
create_veth_pairs() {
    print_info "Creating virtual ethernet pairs..."
    
    # Create veth pair for ns1 <-> br0
    if ! ip link show veth-ns1 &>/dev/null; then
        ip link add veth-ns1 type veth peer name veth-ns1-br
        ip link set veth-ns1 netns ns1
        ip link set veth-ns1-br master br0
        ip link set veth-ns1-br up
        ip netns exec ns1 ip link set veth-ns1 up
        print_info "Created veth pair: ns1 <-> br0"
    else
        print_warn "veth-ns1 already exists"
    fi
    
    # Create veth pair for ns2 <-> br1
    if ! ip link show veth-ns2 &>/dev/null; then
        ip link add veth-ns2 type veth peer name veth-ns2-br
        ip link set veth-ns2 netns ns2
        ip link set veth-ns2-br master br1
        ip link set veth-ns2-br up
        ip netns exec ns2 ip link set veth-ns2 up
        print_info "Created veth pair: ns2 <-> br1"
    else
        print_warn "veth-ns2 already exists"
    fi
    
    # Create veth pair for router <-> br0
    if ! ip link show veth-r-br0 &>/dev/null; then
        ip link add veth-r-br0 type veth peer name veth-r-br0-br
        ip link set veth-r-br0 netns router-ns
        ip link set veth-r-br0-br master br0
        ip link set veth-r-br0-br up
        ip netns exec router-ns ip link set veth-r-br0 up
        print_info "Created veth pair: router <-> br0"
    else
        print_warn "veth-r-br0 already exists"
    fi
    
    # Create veth pair for router <-> br1
    if ! ip link show veth-r-br1 &>/dev/null; then
        ip link add veth-r-br1 type veth peer name veth-r-br1-br
        ip link set veth-r-br1 netns router-ns
        ip link set veth-r-br1-br master br1
        ip link set veth-r-br1-br up
        ip netns exec router-ns ip link set veth-r-br1 up
        print_info "Created veth pair: router <-> br1"
    else
        print_warn "veth-r-br1 already exists"
    fi
}

# Configure IP addresses
configure_ip_addresses() {
    print_info "Configuring IP addresses..."
    
    # Configure ns1
    ip netns exec ns1 ip addr add ${NS1_IP} dev veth-ns1
    ip netns exec ns1 ip link set lo up
    print_info "Configured ns1: ${NS1_IP}"
    
    # Configure ns2
    ip netns exec ns2 ip addr add ${NS2_IP} dev veth-ns2
    ip netns exec ns2 ip link set lo up
    print_info "Configured ns2: ${NS2_IP}"
    
    # Configure router namespace
    ip netns exec router-ns ip addr add ${ROUTER_BR0_IP} dev veth-r-br0
    ip netns exec router-ns ip addr add ${ROUTER_BR1_IP} dev veth-r-br1
    ip netns exec router-ns ip link set lo up
    print_info "Configured router-ns: ${ROUTER_BR0_IP} and ${ROUTER_BR1_IP}"
}

# Configure routing
configure_routing() {
    print_info "Configuring routing..."
    
    # Enable IP forwarding in router namespace
    ip netns exec router-ns sysctl -w net.ipv4.ip_forward=1 >/dev/null
    print_info "Enabled IP forwarding in router-ns"
    
    # Add default route in ns1 (via router)
    ip netns exec ns1 ip route add default via 10.0.1.254
    print_info "Added default route in ns1 via 10.0.1.254"
    
    # Add default route in ns2 (via router)
    ip netns exec ns2 ip route add default via 10.0.2.254
    print_info "Added default route in ns2 via 10.0.2.254"
}

# Verify setup
verify_setup() {
    print_info "Verifying setup..."
    echo ""
    
    print_info "Network Namespaces:"
    ip netns list
    echo ""
    
    print_info "Bridges:"
    ip link show type bridge | grep -E "^[0-9]+:"
    echo ""
    
    print_info "NS1 interfaces and routes:"
    ip netns exec ns1 ip addr show
    ip netns exec ns1 ip route show
    echo ""
    
    print_info "NS2 interfaces and routes:"
    ip netns exec ns2 ip addr show
    ip netns exec ns2 ip route show
    echo ""
    
    print_info "Router namespace interfaces and routes:"
    ip netns exec router-ns ip addr show
    ip netns exec router-ns ip route show
    echo ""
}

# Test connectivity
test_connectivity() {
    print_info "Testing connectivity..."
    echo ""
    
    print_info "Testing ns1 -> router (10.0.1.254):"
    if ip netns exec ns1 ping -c 3 -W 2 10.0.1.254; then
        print_info "✓ ns1 can reach router on br0 network"
    else
        print_error "✗ ns1 cannot reach router on br0 network"
    fi
    echo ""
    
    print_info "Testing ns2 -> router (10.0.2.254):"
    if ip netns exec ns2 ping -c 3 -W 2 10.0.2.254; then
        print_info "✓ ns2 can reach router on br1 network"
    else
        print_error "✗ ns2 cannot reach router on br1 network"
    fi
    echo ""
    
    print_info "Testing ns1 -> ns2 (10.0.2.10) via router:"
    if ip netns exec ns1 ping -c 3 -W 2 10.0.2.10; then
        print_info "✓ ns1 can reach ns2 through router"
    else
        print_error "✗ ns1 cannot reach ns2 through router"
    fi
    echo ""
    
    print_info "Testing ns2 -> ns1 (10.0.1.10) via router:"
    if ip netns exec ns2 ping -c 3 -W 2 10.0.1.10; then
        print_info "✓ ns2 can reach ns1 through router"
    else
        print_error "✗ ns2 cannot reach ns1 through router"
    fi
    echo ""
}

# Main setup function
setup() {
    check_root
    print_info "Starting network namespace simulation setup..."
    echo ""
    
    create_bridges
    create_namespaces
    create_veth_pairs
    configure_ip_addresses
    configure_routing
    
    print_info "Setup completed successfully!"
    echo ""
}

# Cleanup function
cleanup() {
    check_root
    print_info "Cleaning up network namespace simulation..."
    
    # Delete namespaces (this also deletes veth interfaces inside them)
    ip netns del ns1 2>/dev/null || true
    ip netns del ns2 2>/dev/null || true
    ip netns del router-ns 2>/dev/null || true
    print_info "Deleted namespaces"
    
    # Delete veth pairs attached to bridges
    ip link del veth-ns1-br 2>/dev/null || true
    ip link del veth-ns2-br 2>/dev/null || true
    ip link del veth-r-br0-br 2>/dev/null || true
    ip link del veth-r-br1-br 2>/dev/null || true
    
    # Delete bridges
    ip link del br0 2>/dev/null || true
    ip link del br1 2>/dev/null || true
    print_info "Deleted bridges"
    
    print_info "Cleanup completed!"
}

# Script entry point
case "${1:-}" in
    setup)
        setup
        ;;
    verify)
        verify_setup
        ;;
    test)
        test_connectivity
        ;;
    cleanup)
        cleanup
        ;;
    *)
        echo "Usage: $0 {setup|verify|test|cleanup}"
        echo ""
        echo "Commands:"
        echo "  setup   - Create and configure the network simulation"
        echo "  verify  - Verify the current setup"
        echo "  test    - Test connectivity between namespaces"
        echo "  cleanup - Remove all created resources"
        exit 1
        ;;
esac
