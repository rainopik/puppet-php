# == Define php::config::enable
#
# Enables an extension configuration file for Debian systems:
# (creates symlinks in /etc/php5/cli/conf.d and optionally /etc/php5/fpm/conf.d)
define php::config::enable(
  $ensure       = present,
  $inifile      = undef,
  $order        = '20',
) {

  # Inspired by: https://github.com/Mayflower/puppet-php/blob/master/manifests/extension.pp
  if $::osfamily == 'Debian' and versioncmp($::php_version, '5.4') >= 0 {
    $lowercase_title = downcase($title)

    $symlinks = ["${php::cli::params::conf_dir}/${order}-${lowercase_title}.ini"]

    $symlinks_apache = defined(Class['php::apache']) ? {
      true        => ["${php::apache::params::conf_dir}/${order}-${lowercase_title}.ini"],
      default     => [],
    }

    $symlinks_fpm = defined(Class['php::fpm']) ? {
      true        => ["${php::fpm::params::conf_dir}/${order}-${lowercase_title}.ini"],
      default     => [],
    }

    $real_symlinks = concat(concat($symlinks, $symlinks_apache), $symlinks_fpm)

    file { $real_symlinks:
      ensure  => $ensure ? {
          absent    => absent,
          default   => link,
      },
      target  => $inifile,
      require => Php::Config["php-extension-${title}"],
    }
  }

}
