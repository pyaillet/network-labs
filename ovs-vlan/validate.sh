#!/usr/bin/env bash

pc1="docker container exec clab-ovs-vlan-pc1-1"
pc2="docker container exec clab-ovs-vlan-pc2-3"

echo "From pc1-1..."

echo "✅ Testing ping from pc1-1 to pc1-2"
$pc1 ping -c 1 -w 1 192.168.5.3

echo "❌ Testing ping from pc1-1 to pc1-3"
$pc1 ping -c 1 -w 1 192.168.5.4

echo "❌ Testing ping from pc1-1 to pc1-4"
$pc1 ping -c 1 -w 1 192.168.5.5

echo "✅ Testing ping from pc1-1 to pc2-1"
$pc1 ping -c 1 -w 1 192.168.5.6

echo "✅ Testing ping from pc1-1 to pc2-2"
$pc1 ping -c 1 -w 1 192.168.5.7

echo "❌ Testing ping from pc1-1 to pc2-3"
$pc1 ping -c 1 -w 1 192.168.5.8

echo "❌ Testing ping from pc1-1 to pc2-4"
$pc1 ping -c 1 -w 1 192.168.5.9

echo "From pc2-3..."

echo "❌ Testing ping from pc2-3 to pc1-1"
$pc2 ping -c 1 -w 1 192.168.5.2

echo "❌ Testing ping from pc2-3 to pc1-2"
$pc2 ping -c 1 -w 1 192.168.5.3

echo "✅ Testing ping from pc2-3 to pc1-3"
$pc2 ping -c 1 -w 1 192.168.5.4

echo "✅ Testing ping from pc2-3 to pc1-4"
$pc2 ping -c 1 -w 1 192.168.5.5

echo "❌ Testing ping from pc2-3 to pc2-1"
$pc2 ping -c 1 -w 1 192.168.5.6

echo "❌ Testing ping from pc2-3 to pc2-2"
$pc2 ping -c 1 -w 1 192.168.5.7

echo "✅ Testing ping from pc2-3 to pc2-4"
$pc2 ping -c 1 -w 1 192.168.5.9
