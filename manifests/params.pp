# == Class: newrelic::params
#
# This class handles parameters for the newrelic module
#
# == Actions:
#
# None
#
# === Authors:
#
# Felipe Salum <fsalum@gmail.com>
# Craig Watson <craig.watson@claranet.uk>
#
# === Copyright:
#
# Copyright 2012 Felipe Salum
# Copyright 2017 Claranet
#
class newrelic::params {

  case $facts['os']['family'] {
    'RedHat': {
      $manage_repo         = true
      $manage_unzip        = true
      $server_package_name = 'newrelic-sysmond'
      $server_service_name = 'newrelic-sysmond'
      $php_package_name    = 'newrelic-php5'
      $php_service_name    = 'newrelic-daemon'
      $php_conf_dir        = '/etc/php.d'
      $php_extra_packages  = ['php-cli']
      $run_installer       = true

      if $facts['os']['release']['major'] == '7' {
        # Abstract socket
        # - https://discuss.newrelic.com/t/apm-not-showing-data-php-5-6-centos-7-apache-httpd-2-4/30756/5
        $php_default_ini_settings = {
          'daemon.port' => '"@newrelic-daemon"'
        }
        $php_default_daemon_settings = {
          'port' => '"@newrelic-daemon"'
        }
      } else {
        $php_default_ini_settings = {}
        $php_default_daemon_settings = {}
      }
    }

    'Debian': {
      $manage_repo                 = true
      $manage_unzip                = true
      $server_package_name         = 'newrelic-sysmond'
      $server_service_name         = 'newrelic-sysmond'
      $php_package_name            = 'newrelic-php5'
      $php_service_name            = 'newrelic-daemon'
      $php_default_ini_settings    = {}
      $php_default_daemon_settings = {}
      $php_extra_packages          = []
      $run_installer               = false

      case $facts['os']['distro']['codename'] {
        'xenial','stretch': { $php_conf_dir = '/etc/php/7.0/mods-available' }
        default:            { $php_conf_dir = '/etc/php5/mods-available' }
      }
    }

    'Windows': {
      $manage_repo             = false
      $manage_unzip            = false
      $bitness                 = regsubst($facts['os']['architecture'],'^x([\d]{2})','\1')
      $server_package_name     = 'New Relic Server Monitor'
      $server_service_name     = 'nrsvrmon'
      $temp_dir                = 'C:/Windows/temp'
      $server_monitor_source   = 'http://download.newrelic.com/windows_server_monitor/release/'
      $dotnet_conf_dir         = 'C:\\ProgramData\\New Relic\\.NET Agent'
      $dotnet_package          = "New Relic .NET Agent (${bitness}-bit)"
      $dotnet_source           = 'http://download.newrelic.com/dot_net_agent/release/'
      $dotnet_application_name = 'My Application'
    }

    default: {
      fail("Unsupported osfamily: ${facts[osfamily]} operatingsystem: ${facts[operatingsystem]}")
    }
  }

}
