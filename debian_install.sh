#!/bin/bash

apt-get install tor
cp ./torrc /etc/tor/torrc
cp torify.init /etc/init.d/torify
chmod 755 /etc/init.d/torify
ln -s /etc/init.d/torify /etc/rc3.d/S40torify
update-rc.d torify enable


