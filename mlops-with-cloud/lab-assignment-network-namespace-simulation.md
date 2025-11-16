### background
network namespaces in Linux allow for the creation of isolated network environments within a single host. This assignment will help you understand how to create and manage multiple network namespaces and connect them using bridges and routing.

### main objective
Create a network simulation with two separate networks connected via a router using Linux network namespaces and bridges.

### required components

- **network bridges**
	- bridge 0 (br0)
	- bridge 1 (br1)
- **network namespaces**
	- namespace 1 (ns1) - connected to br0
	- namespace 2 (ns2) - connected to br1
	- router namespace (router) - connects both bridges

### required tasks
- create network bridges
	- set up br0 and br1
	- ensure bridges are properly configured and active

- create network namespaces
	- create three separate network namespaces (ns1, ns2, router-ns)
	- verify namespace creation

- create virtual interfaces and connections
	- create appropriate virtual ethernet (veth) pairs
	- connect interfaces to correct namespaces
	- connect interfaces to appropriate bridges

- configure IP addresses
	- assign appropriate IP addresses to all interfaces
	- ensure proper subnet configuration
	- document your IP addressing scheme

- set up routing
	- configure routing between namespaces
	- enable IP forwarding where necessary
	- establish default routes

- enable and test connectivity
	- ensure ping works between ns1 and ns2
	- document and test all network paths
	- verify full connectivity

### bonus challenge

Implement your solution using either: •⁠ ⁠A bash script for automation •⁠ ⁠A Makefile for automated setup and teardown

### deliverables

- Complete implementation (either manual commands or automation script)
- Network diagram showing your topology
- Documentation of:
	- IP addressing scheme
	- Routing configuration
	- Testing procedures and results

### technical requirements
- All commands must be executed with root privileges
- Solution must work on a standard Linux system

### evaluation criteria
- Correct network topology implementation
- Proper isolation between namespaces
- Successful routing between networks
- Code quality (if automation is implemented)
- Documentation quality

### note
Remember to add a clean up function to clean your network namespaces and bridges after testing to avoid conflicts with other network configurations.