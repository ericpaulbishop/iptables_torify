#!/bin/bash

tor_user="debian-tor"
dns_port="9061"
trans_port="9051"

for table in nat filter ; do

	target="ACCEPT"
	if [ "$table" = "nat" ] ; then
		target="RETURN"
	fi

	#initialize output chain
	iptables -t $table -F OUTPUT

	#ignore already established connections
	iptables -t $table -A OUTPUT -m state --state ESTABLISHED -j $target

	#don't send tor traffic through tor again
	iptables -t $table -A OUTPUT -m owner --uid debian-tor  -j $target


	#handle dns traffic
	match_dns_port="$dns_port"
	if [ "$table" = "nat" ] ; then
		target="REDIRECT --to-ports $dns_port"
		match_dns_port=53
	fi
	iptables -t $table -A OUTPUT -p udp --dport $match_dns_port -j $target
	iptables -t $table -A OUTPUT -p tcp --dport $match_dns_port -j $target



	# don't send local/loopback stuff through tor
	# all dns requests have already been sent to tor
	# so, we don't have to worry about handling that specially
	if [ "$table" = "nat" ] ; then
		target="RETURN"
	fi
	iptables -t $table -A OUTPUT -d 127.0.0.1/8    -j $target
	iptables -t $table -A OUTPUT -d 192.168.0.0/16 -j $target
	iptables -t $table -A OUTPUT -d 172.16.0.0/12  -j $target
	iptables -t $table -A OUTPUT -d 10.0.0.0/8     -j $target

	

	#handle tcp traffic
	if [ "$table" = "nat" ] ; then
		target="REDIRECT --to-ports $trans_port"
	fi
	iptables -t $table -A OUTPUT -p tcp -j $target
done

#block non-local udp/icmp traffic
iptables -t filter -A OUTPUT -p udp -j REJECT
iptables -t filter -A OUTPUT -p icmp -j REJECT


