#!/bin/bash

if [ $# -eq 0 ]; then
	echo "Arguments needed"
	exit
fi
	/etc/init.d/frr start
	ip link add br0 type bridge
	ip link set dev br0 up
	ip addr add 10.1.1.$1/24 dev eth0
	ip link add name vxlan10 type vxlan id 10 dev eth0 group 239.1.1.1 dstport 4789
	ip addr add 20.1.1.$1/24 dev vxlan10
	ip link set eth1 master br0
	ip link set eth1 up
	ip link set vxlan10 master br0
	ip link set vxlan10 up
