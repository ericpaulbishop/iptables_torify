#!/bin/bash

apt-get install tor
cp ./torrc /etc/tor/torrc
cp torify.init /etc/init.d/torify
chmod 755 /etc/init.d/torify
update-rc.d torify defaults
update-rc.d torify enable

/etc/init.d/tor restart
/etc/init.d/torify restart


