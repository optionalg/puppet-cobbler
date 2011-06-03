class cobbler::setup {
	file { "/var/lib/cobbler/loaders":
		ensure => directory,
		owner => root,
		group => root,
		mode => 755,
		require => Service["cobblerd"],
	}

	exec { "cobblerloaders":
		path => "/usr/bin/",
		command => "cobbler get-loaders",
		unless => "test -f /var/lib/cobbler/loaders/pxelinux.0",
		require => File["/var/lib/cobbler/loaders"],
	}

	file { "/var/lib/tftpboot":
		ensure => directory,
		owner => root,
		group => root,
		mode => 0755,
		require => Service["cobblerd"],
	}

	exec { "/var/lib/tftpboot":
		path => "/bin/:/usr/bin/",
		command => "cp /var/lib/cobbler/loaders/* /var/lib/tftpboot",
		unless => "test -f /var/lib/tftpboot/pxelinux.0",
		require => File["/var/lib/tftpboot"],
	}
}
