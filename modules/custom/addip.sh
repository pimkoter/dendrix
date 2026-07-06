#!/usr/bin/env bash
printf "What ip address would you like to add?\n"
read -p "" adress
sudo ip addr add dev enp6s0 ${adress}
echo "Added ip $adress"
