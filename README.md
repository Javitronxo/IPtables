# IPtables example for your Web and Email Server

IPtables is a firewall administration program implementes within the Linux operative system. It works at the IP network and Transport Protocol Layers, and makes decisions after filtering packed based on the information in the IP packet header.

This particular example is focused on Web and Email Servers, it covers remote conections, web applications, and email services.

In order to make it as safer as possible, the default policy for the firewall is to deny everithing. If the incoming IP packet doesn't match any rule the firewall will drop it, therefore you have to define beforehand the services you want to provide. Easier than block all the port you don't want to use!

## Services and ports I will use for my personal firewall:

* SSH: 22
* HTTP: 80
* HTTPS: 443
* SMTP: 25
* SMTP over SSH: 465
* IMAP: 143
* IMAP: 993
* POP: 110
* POPS: 995
* Webmin: 10000 (Webmin is a web-based interface for system administration for Unix.)

## Instructions to use: As root user

Execute the script & Check the rules afterwards
	
	./web_firewall.sh
	iptables -L

Output example:

	Chain INPUT (policy DROP)
	target     prot opt source               destination
	ACCEPT     all  --  anywhere             anywhere
	ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:ssh state NEW,ESTABLISHED
	ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:http state NEW,ESTABLISHED
	ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:https state NEW,ESTABLISHED
	ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:smtp state NEW,ESTABLISHED
	ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:ssmtp state NEW,ESTABLISHED
	ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:imap2 state NEW,ESTABLISHED
	ACCEPT     tcp  --  192.168.1.0/24       anywhere             tcp dpt:webmin state NEW,ESTABLISHED
	ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:http limit: avg 25/min burst 100
	ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:433 limit: avg 25/min burst 100

	Chain FORWARD (policy DROP)
	target     prot opt source               destination

	Chain OUTPUT (policy DROP)
	target     prot opt source               destination
	ACCEPT     all  --  anywhere             anywhere
	ACCEPT     tcp  --  anywhere             anywhere             tcp spt:ssh state ESTABLISHED
	ACCEPT     tcp  --  anywhere             anywhere             tcp spt:http state ESTABLISHED
	ACCEPT     tcp  --  anywhere             anywhere             tcp spt:https state ESTABLISHED
	ACCEPT     tcp  --  anywhere             anywhere             tcp spt:smtp state ESTABLISHED
	ACCEPT     tcp  --  anywhere             anywhere             tcp spt:ssmtp state ESTABLISHED
	ACCEPT     tcp  --  anywhere             anywhere             tcp spt:imap2 state ESTABLISHED
	ACCEPT     tcp  --  anywhere             anywhere             tcp spt:webmin state ESTABLISHED

## Other security considerations:

Since our machine will act always as server and not as client, we can improve the security level checking the state of the TCP connection. Defining the rules accoding to the state flag and the packet source.

IPtables includes the option --state option, which allows access to the connection tracking state for this packet, only the states defined will be matched by the rule.

To make the most of this option, the incoming packets must be marked as NEW (connection) or ESTABLISHED (connection), and the outcoming packets as ESTABLISHED. This way the firewall will be able to prevent the packets that violate the TCP specification.
