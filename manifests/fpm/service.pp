class php::fpm::service(
  $service_name,
  $ensure,
  $enable,
  $has_status,
) {

  service { $service_name:
    ensure    => $ensure,
    enable    => $enable,
    restart   => "service ${service_name} reload",
    hasstatus => $has_status
  }

}
