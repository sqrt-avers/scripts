#!/bin/bash

# For bridge using
apt get install -y bridge-utils
# OVS
apt get install -y openvswitch-common
# For vlan using
apt get install -y vlan
# For port bonding
apt get install -y ifenslave

# Create new ovs bridge and connect it with physical port
ovs-vsctl add-br br-ext
ovs-vsctl add-port br-ext ens3

# For OVS using change /etc/network/interfaces
cat <<EOT > /etc/network/interfaces
# The loopback network interface
auto lo
iface lo inet loopback

#### For OVS its possible ####

# Enable physical port #
allow-br-ext ens3
iface ens3 inet manual
ovs_bridge br-ext
ovs_type OVSPort

# Configure OVS bridge #
auto br-ext
allow-ovs br-ext
iface br-ext inet dhcp
#address 10.10.10.253/24 For static
ovs_type OVSBridge
ovs_ports ens3

#### For linux bridge its possible ####

#auto ens3
#iface ens3 inet manual
#auto br-ext
#iface br-ext inet dhcp
#bridge_ports ens3
EOT

# Create veth pair to use between bridges
ip link add tap-int-ext type veth peer name tap-ext-int
