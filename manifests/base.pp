class cobbler::base {
	include httpd
	include xinetd
	include xinetd::tftp
	include xinetd::rsync
	include cobbler::setup

	package { "cobbler":
		ensure => installed,
		notify => Service["cobblerd"],
	}

	service { "cobblerd":
		ensure => running,
		enable => true,
		require => [ Service["httpd", "xinetd"], Package["cobbler"] ],
	}

	exec { "cobblersync":
		path => "/usr/bin/",
		command => "sudo cobbler sync",
	}

	exec { "cobblercheck":
		path => "/usr/bin/",
		command => "sudo cobbler check",
	}
}
