class cobbler::config {
	$cobblersource = $hostname ? {
		centos-server => "puppet:///config/cobbler::centos-server",
		default => "puppet:///config/cobbler",
	}

	file { "/etc/cobbler/settings":
		ensure => present,
		owner => root,
		group => root,
		mode => 0664,
		source => $hostname ? { centos-server => "puppet:///config/cobbler::centos-server", default => "puppet:///config/cobbler", },
	}

	file { "/etc/cobbler/modules.conf":
		ensure => present,
		owner => root,
		group => root,
		mode => 0644,
		source => "puppet:///config/cobblermodules",
	}
}
