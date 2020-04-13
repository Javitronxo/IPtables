#!/bin/sh

#############################################
# IPTABLES for a Secure Web and Email Server
#
# Javitronxo - February 2015
# www.prohus.net
# webmaster@prohus.net
#############################################

echo "Running the script.."
echo "Flushing existing rules.."
#Flush existing rules
iptables -F
iptables -X
iptables -Z
iptables -t nat -F

echo "Default policy: DROP"
#Set default policy: DROP
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP

echo "Applying rules.."
#Allow loopback processes
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Accept all established inbound connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

#Allow incoming SSH
iptables -A INPUT -i eth0 -p tcp -m state --state NEW --dport 22 -j ACCEPT

#Allow incoming HTTP and HTTPS
iptables -A INPUT -i eth0 -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 443 -j ACCEPT

#Allow SMTP and SMTP_SSL
sudo iptables -A INPUT -i eth0 -p tcp --dport 25 -j ACCEPT
sudo iptables -A INPUT -i eth0 -p tcp --dport 465 -j ACCEPT
sudo iptables -A INPUT -i eth0 -p tcp --dport 587 -j ACCEPT

#Allow IMAP and IMAPS
iptables -A INPUT -i eth0 -p tcp --dport 143 -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 993 -j ACCEPT

#Allow POP and POPS
iptables -A INPUT -i eth0 -p tcp --dport 110 -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 995 -j ACCEPT

#Prevent DoS Attack
iptables -A INPUT -p tcp --dport 80 -m limit --limit 25/minute --limit-burst 100 -j ACCEPT
iptables -A INPUT -p tcp --dport 433 -m limit --limit 25/minute --limit-burst 100 -j ACCEPT

# Log iptables denied calls
iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level 7

echo "Done."
