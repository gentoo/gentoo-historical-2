# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/kismet/files/kismet-2005.01.1-conf.d,v 1.1 2005/01/16 19:29:44 brix Exp $

# Config file for kismet server

# ATTENTION: most of the kismet configuration is still done in
# /etc/kismet.conf
# To use the kismet init script, you must have "logtemplate" set to a location
# that is writable by the user assigned by "suiduser".
# e.g.
# suiduser=foo
# logtemplate=%h/kismet_log/%n-%d-%i.%l


# Set WIFI_DEV to the device to be used by the kismet server.
# This device must have the ability to do monitor mode


WIFI_DEV=""

# WIFI_DEV="wlan0"
# WIFI_DEV="eth1"

# Options to pass to the hopper/monitor/server
KISMET_MONITOR_OPTS=""
KISMET_SERVER_OPTS=""
