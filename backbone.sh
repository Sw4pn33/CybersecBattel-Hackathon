#!/bin/bash

# I have written this code to check whether the user is a root user or not
if [ "$EUID" -ne 0 ]; then
    echo -e "\e[1;31m[!] Please run this script with sudo.\e[0m"
    exit 1
fi

echo -e "\e[0m"

echo -e "\e[1;33m[+] Setting up firewall rules: Allowing traffic on port 80... \e[0m"
ufw allow 80 > /dev/null 2>&1 || { echo -e "\e[1;31m[!] Error setting up firewall rules\e[0m"; exit 1; }

echo -e "\n"

echo -e "\e[1;33m[+] Enabling UFW firewall... \e[0m"
ufw enable && ufw reload > /dev/null 2>&1 || { echo -e "\e[1;31m[!] Error enabling or reloading the firewall rules\e[0m"; exit 1; }

echo -e "\n"

echo -e "\e[1;33m[+] Activating Tor service... \e[0m"
service tor start && service tor restart  > /dev/null 2>&1 || { echo -e "\e[1;31m[!] Error starting or restarting the Tor service\e[0m"; exit 1; }

echo -e "\n"

sleep 5 

echo -e "\e[1;33m[+] Configuring Tor Hidden Service \e[0m"
sudo sed -i '/## HiddenServicePort x y:z/a \
HiddenServiceDir /var/lib/tor/sdb/ \
HiddenServiceVersion 3 \
HiddenServicePort 80 127.0.0.1:80' /etc/tor/torrc && service tor restart > /dev/null 2>&1 || { echo -e "\e[1;31m[!] Error Unable to set up hidden service\e[0m"; exit 1; }

sleep 5 

