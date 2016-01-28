class self_hostname(
  $ensure_canonical_hostname  = false,
  $remove_hostname            = false,
) {
  # 127.0.1.1 makes apache not yell for not being able to resolve fqdn
    augeas { 'removal_in_etc_hosts':
        context => '/files/etc/hosts',
        changes => [
            "rm *[ipaddr = '127.0.1.1']",
        ]
    }
    if !str2bool($remove_hostname){
        host { $::fqdn:
            ensure       => present,
            ip           => '127.0.1.1',
            host_aliases => [$::hostname, 'localhost'],
            require      => augeas['removal_in_etc_hosts'],
        }
    }

    # Ensure Java 1.7 picks up $::fqdn as CanonicalHostName instead of 'localhost'...
    if (str2bool($ensure_canonical_hostname)) {
        host { $::hostname:
            ensure => absent,
            ip     => '127.0.0.1'
        }
        host { 'localhost':
            ensure => present,
            ip     => '127.0.0.1',
        }
    }
}