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
* SMTP/STARTTLS: 587
* IMAP: 143
* IMAP: 993
* POP: 110
* POPS: 995

## Instructions to use: As root user

Execute the script & Check the rules afterwards
	
	./web_firewall.sh
	iptables -L

Output example:

	Chain INPUT (policy DROP)
	target     prot opt source               destination
	REJECT     all  --  anywhere             loopback/8           reject-with icmp-port-unreachable
	ACCEPT     all  --  anywhere             anywhere             state RELATED,ESTABLISHED
	ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:http
	ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:https
	ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:smtp
	ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:ssmtp
	ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:submission
	ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:pop3
	ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:pop3s
	ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:imap2
	ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:imaps
	ACCEPT     tcp  --  anywhere             anywhere             state NEW tcp dpt:ssh
	ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:http limit: avg 25/min burst 100
	ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:433 limit: avg 25/min burst 100
	LOG        all  --  anywhere             anywhere             limit: avg 5/min burst 5 LOG level debug prefix "iptables denied: "

	Chain FORWARD (policy DROP)
	target     prot opt source               destination
	DROP       all  --  anywhere             anywhere

	Chain OUTPUT (policy ACCEPT)
	target     prot opt source               destination
	ACCEPT     all  --  anywhere             anywhere

## Other security considerations:

Since our machine will act always as server and not as client, we can improve the security level checking the state of the TCP connection. Defining the rules accoding to the state flag and the packet source.

IPtables includes the option --state option, which allows access to the connection tracking state for this packet, only the states defined will be matched by the rule.

To make the most of this option, the incoming packets must be marked as NEW (connection) or ESTABLISHED (connection). This way the firewall will be able to prevent the packets that violate the TCP specification.
