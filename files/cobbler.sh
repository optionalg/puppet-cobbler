# Script to automatically setup a cobbler/puppet demo setup

# First off we define some variables:
# cobbler server-ip:
  cobbler-ip=192.168.122.1

# then there's a few packages you'll want to install:
# cobbler is the base package so it's required
# cobbler-web is a web-interface to cobbler in case you wanna go gui
# debmirror in case you also want to do debian deployments
# dhcp if you plan on using cobbler with real machines and don't have another dhcp server you can configure
  packages="cobbler cobbler-web debmirror dhcp"

# install the packages
  sudo yum -y install $packages

# Next up we edit some config files:
# edit /etc/cobbler/settings and change "server" and "next_server" vars to the servers ip
  sudo sed -i 's/127.0.0.1/$cobbler-ip/g' /etc/cobbler/settings	

sudo cobbler get-loaders

# edit /etc/xinetd.d/tftp and /etc/xinetd.d/rsync and set var "disabled" to "no"
  sudo sed -i 's/"disable\t\t= yes"/"disable\t\t= no"/'	/etc/xinetd.d/tftp
  sudo sed -i 's/"disable\t\t= yes"/"disable\t\t= no"/'	/etc/xinetd.d/rsync

# edit /etc/debmirror.conf if you want to use it
  sudo sed -i 's/"@dists"/"#@dists"/' /etc/debmirror.conf
  sudo sed -i 's/"@arches"/"#@arches"/' /etc/debmirror.conf

# then we edit the firewall config to open up ports 69 (tftp), 80 (http) and 25151 (cobbler)
# TFTP ports:
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 69 -j ACCEPT
iptables -A INPUT -m state --state NEW -m udp -p udp --dport 69 -j ACCEPT
# HTTPD ports:
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT
# Cobbler and Koan XMLRPC ports:
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 25151 -j ACCEPT
# and then we save the iptables rules:
iptables-save

# restart the cobblerd, run "cobbler sync" to push changes and "cobbler check" to check settings
# if something's wrong with your settings, "cobbler check" should point this out to you
  sudo /etc/init.d/cobblerd restart && sudo cobbler sync && sudo cobbler check

# Now we can start importing distributions
# there's multiple ways to do this: from local media, rsync mirrors or even nfs shares
# currently there's no support for live-cd's, because cobbler can't handle squashfs

# we'll start with the local media:
  sudo cobbler import --path=/path/to/media/dir --name=newdist

# this is the rsync mirror method:
  sudo cobbler import --path=rsync://ftp.halifax.rwth-aachen.de/fedora/linux --name=F14
