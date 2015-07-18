# == Class: uzblmonitor
#
# Full description of class uzblmonitor here.
#
# === Parameters
#
# Document parameters here.
#
# [*example_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
# === Variables
#
# List of variables this module requires and uses.
#
# [*example_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default.
#
# === Examples
#
#  class { 'uzblmonitor':
#  # ...
#  }
#
class uzblmonitor (
  $statefile = '/home/monitor/uzblmonitor-state.json'
) {

  $quoted_statefile = shellquote($statefile)

  # Remove stock-Ubuntu DM packages
  package { ['lightdm', 'ubuntu-session', 'unity', 'unity-greeter']:
    ensure => purged,
  } ->

  # Install NoDM and Matchbox for kiosk-style display/window management
  package { ['xserver-xorg', 'nodm', 'luakit', 'xterm', 'tmux', 'i3', 'python-pip']:
    ensure => installed,
  } ->
  package { 'i3-py' :
    ensure   => '0.6.4',
    provider => 'pip'
  }

  package { 'browser-plugin-gnash':
    ensure => installed,
  }

  user { 'monitor':
    ensure     => present,
    managehome => true,
  } ->
  file { '/home/monitor/.xsession':
    ensure => file,
    owner  => monitor,
    group  => monitor,
    mode   => '0444',
    source => 'puppet:///modules/uzblmonitor/xsession',
  } ->
  file{'/home/monitor/.i3/':
    ensure => directory,
  } ->
  file { '/home/monitor/.i3/config':
    ensure => file,
    owner  => monitor,
    group  => monitor,
    source => 'puppet:///modules/uzblmonitor/i3_config',
  } ->
  file { '/etc/init/nodm-uzblmonitor.conf':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0444',
    source => 'puppet:///modules/uzblmonitor/nodm-uzblmonitor.conf',
  } ->
  file { '/etc/default/nodm-uzblmonitor':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0444',
    source => 'puppet:///modules/uzblmonitor/nodm-uzblmonitor.default',
  } ->
  service { 'nodm-uzblmonitor':
    ensure  => running,
    require => Package['nodm'],
  }

  file { '/usr/bin/uzblmonitor':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0755',
    source => 'puppet:///modules/uzblmonitor/uzblmonitor',
  } ->
  file { '/etc/default/uzblmonitor':
    content => "STATEFILE=${quoted_statefile}",
    notify => Service['uzblmonitor'],
  } ->
  file { '/etc/init/uzblmonitor.conf':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0444',
    source => 'puppet:///modules/uzblmonitor/uzblmonitor.conf',
  } ->
  service { 'uzblmonitor':
    ensure  => running,
    require => Service['nodm-uzblmonitor'],
  }

}
