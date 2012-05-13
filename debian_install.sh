#!/bin/bash

apt-get install tor
cp ./torrc /etc/tor/torrc
cp torify.init /etc/init.d/torify
chmod 755 /etc/init.d/torify
for rcn in 2 3 4 5 ; do
	ln -s /etc/init.d/torify /etc/rc${rcn}.d/S40torify
done
update-rc.d torify enable


