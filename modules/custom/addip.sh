#!/usr/bin/env bash
read -p "What adress would you like to add?\n" adress
sudo ip addr add dev enp6s0 ${adress}
echo "Added ip $adress"
