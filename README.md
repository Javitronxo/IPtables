# IPtables example for your Web and Email Server

Services and ports I will use for my personal firewall:

* SSH: 22
* HTTP: 80
* HTTPS: 443
* SMTP: 25
* SMTP over SSH: 465
* IMAP: 143
* IMAP: 993
* Webmin: 10000 (I like to use this program sometimes...)

## Instructions to use: As root user

Execute the script
* ./web_firewall.sh

Check the rules afterwards
* iptables -L