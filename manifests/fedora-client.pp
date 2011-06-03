class cobbler::fedora-client {
	exec { "download":
		path => "/bin/:/usr/bin/",
		command => "wget -rnp http://192.168.122.1/fedora/ -P /var/www/html/",
		unless => "cobbler profile list|grep -i f14-i386",
	}

	exec { "clean_wget":
		path => "/bin/:/usr/bin/",
		command => "find /var/www/html/192.168.122.1/ -name \"index.*\" -print|xargs rm",
		onlyif => "test -f /var/www/html/192.168.122.1/fedora/index.html",
	}

	exec { "import":
		path => "/bin/:/usr/bin/",
		command => "cobbler import --name='f14_i386' --path='/var/www/html/192.168.122.1/fedora/' --arch=i386",
		unless => "cobbler profile list|grep -i f14-i386",
	}

	exec { "system_fedora-client":
		path => "/bin/:/usr/bin/",
		command => "cobbler system add --name='fedora-client' --profile='f14-i386' --mac='52:54:00:84:CB:17' --kickstart='http://192.168.122.1/kickstart/fedora-client.ks'",
		unless => "cobbler system list|grep -i f14-i386",
		require => Exec["import"],
	}
}
