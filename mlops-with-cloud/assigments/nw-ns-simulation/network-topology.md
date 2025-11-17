# Network Namespace Simulation - Topology Diagram

## Network Topology

```mermaid
graph TB
    subgraph "Network 1 (10.0.1.0/24)"
        NS1[Namespace: ns1<br/>IP: 10.0.1.10/24<br/>Interface: veth-ns1]
        BR0[Bridge: br0]
        VETH_NS1_BR[veth-ns1-br]
        VETH_R_BR0_BR[veth-r-br0-br]
    end
    
    subgraph "Router Namespace (router-ns)"
        ROUTER[Router<br/>veth-r-br0: 10.0.1.254/24<br/>veth-r-br1: 10.0.2.254/24<br/>IP Forwarding: Enabled]
        VETH_R_BR0[veth-r-br0]
        VETH_R_BR1[veth-r-br1]
    end
    
    subgraph "Network 2 (10.0.2.0/24)"
        NS2[Namespace: ns2<br/>IP: 10.0.2.10/24<br/>Interface: veth-ns2]
        BR1[Bridge: br1]
        VETH_NS2_BR[veth-ns2-br]
        VETH_R_BR1_BR[veth-r-br1-br]
    end
    
    NS1 ---|veth pair| VETH_NS1_BR
    VETH_NS1_BR ---|attached| BR0
    VETH_R_BR0_BR ---|attached| BR0
    VETH_R_BR0_BR ---|veth pair| VETH_R_BR0
    VETH_R_BR0 ---|inside| ROUTER
    
    VETH_R_BR1 ---|inside| ROUTER
    VETH_R_BR1 ---|veth pair| VETH_R_BR1_BR
    VETH_R_BR1_BR ---|attached| BR1
    VETH_NS2_BR ---|attached| BR1
    VETH_NS2_BR ---|veth pair| NS2
    
    style NS1 fill:#e1f5ff,stroke:#01579b,stroke-width:2px
    style NS2 fill:#e1f5ff,stroke:#01579b,stroke-width:2px
    style ROUTER fill:#fff3e0,stroke:#e65100,stroke-width:3px
    style BR0 fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    style BR1 fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
```

## Simplified View

```mermaid
graph LR
    NS1[ns1<br/>10.0.1.10]
    ROUTER[router-ns<br/>10.0.1.254 ↔ 10.0.2.254]
    NS2[ns2<br/>10.0.2.10]
    
    NS1 ---|br0<br/>10.0.1.0/24| ROUTER
    ROUTER ---|br1<br/>10.0.2.0/24| NS2
    
    style NS1 fill:#e1f5ff,stroke:#01579b,stroke-width:2px
    style NS2 fill:#e1f5ff,stroke:#01579b,stroke-width:2px
    style ROUTER fill:#fff3e0,stroke:#e65100,stroke-width:3px
```

## Traffic Flow Diagram

```mermaid
sequenceDiagram
    participant NS1 as ns1<br/>(10.0.1.10)
    participant BR0 as Bridge br0<br/>(10.0.1.0/24)
    participant ROUTER as router-ns<br/>(10.0.1.254 / 10.0.2.254)
    participant BR1 as Bridge br1<br/>(10.0.2.0/24)
    participant NS2 as ns2<br/>(10.0.2.10)
    
    Note over NS1,NS2: Ping from ns1 to ns2 (10.0.2.10)
    
    NS1->>BR0: Packet to 10.0.2.10<br/>(via default route 10.0.1.254)
    BR0->>ROUTER: Forward to router (veth-r-br0)
    Note over ROUTER: IP forwarding enabled<br/>Routes packet between networks
    ROUTER->>BR1: Forward to br1 (veth-r-br1)
    BR1->>NS2: Deliver to ns2
    
    NS2-->>BR1: Reply packet
    BR1-->>ROUTER: Forward to router
    ROUTER-->>BR0: Forward to br0
    BR0-->>NS1: Deliver reply to ns1
    
    Note over NS1,NS2: Connection established!
```

## Component Details

### Network Namespaces
- **ns1**: Client namespace in network 1
- **ns2**: Client namespace in network 2
- **router-ns**: Router namespace connecting both networks

### Bridges
- **br0**: Virtual switch for network 1 (10.0.1.0/24)
- **br1**: Virtual switch for network 2 (10.0.2.0/24)

### Virtual Ethernet Pairs
1. **veth-ns1 ↔ veth-ns1-br**: Connects ns1 to br0
2. **veth-ns2 ↔ veth-ns2-br**: Connects ns2 to br1
3. **veth-r-br0 ↔ veth-r-br0-br**: Connects router-ns to br0
4. **veth-r-br1 ↔ veth-r-br1-br**: Connects router-ns to br1

### IP Addressing Scheme

| Component | Interface | IP Address | Network |
|-----------|-----------|------------|---------|
| ns1 | veth-ns1 | 10.0.1.10/24 | Network 1 |
| router-ns | veth-r-br0 | 10.0.1.254/24 | Network 1 |
| router-ns | veth-r-br1 | 10.0.2.254/24 | Network 2 |
| ns2 | veth-ns2 | 10.0.2.10/24 | Network 2 |

### Routing Configuration

**ns1 routing table:**
- Default route: via 10.0.1.254 (router-ns on br0)

**ns2 routing table:**
- Default route: via 10.0.2.254 (router-ns on br1)

**router-ns:**
- IP forwarding: Enabled
- Connected routes: 10.0.1.0/24 and 10.0.2.0/24
