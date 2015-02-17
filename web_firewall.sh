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
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

echo "Applying rules.."
#Allow loopback processes
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

#Allow incoming SSH
iptables -A INPUT -i eth0 -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT

#Allow incoming HTTP and HTTPS
iptables -A INPUT -i eth0 -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 80 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 443 -m state --state ESTABLISHED -j ACCEPT

#Allow SMTP and SMTP_SSL
iptables -A INPUT -i eth0 -p tcp --dport 25 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 25 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 465 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 465 -m state --state ESTABLISHED -j ACCEPT

#Allow IMAP and IMAPS
iptables -A INPUT -i eth0 -p tcp --dport 143 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 143 -m state --state ESTABLISHED -j ACCEPT

#Allow Webmin Web GUI only from your LAN
iptables -A INPUT -i eth0 -p tcp -s 192.168.1.0/24  --dport 10000 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 10000 -m state --state ESTABLISHED -j ACCEPT

#Prevent DoS Attack
iptables -A INPUT -p tcp --dport 80 -m limit --limit 25/minute --limit-burst 100 -j ACCEPT
iptables -A INPUT -p tcp --dport 433 -m limit --limit 25/minute --limit-burst 100 -j ACCEPT

echo "Done."
echo "Check your tables typing:"
echo "  $ sudo iptables -L"
