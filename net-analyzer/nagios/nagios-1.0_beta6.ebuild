# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nagios/nagios-1.0_beta6.ebuild,v 1.1 2002/11/02 05:55:41 alron Exp $

DESCRIPTION="Nagios $PV - merge this to pull install all of the nagios packages"
HOMEPAGE="http://www.nagios.org/"
RDEPEND=`echo ~net-analyzer/nagios-{core-1.0_beta6,plugins-1.3_beta1,nrpe-1.5,nsca-2.1,imagepack-1.0}`

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"
pkg_postinst() {
	einfo
	einfo "Remember to edit the config files in /etc/nagios"
	einfo "Also, if you want nagios to start at boot time"
	einfo "remember to execute rc-update add nagios default"
	einfo
	einfo "To have nagios visable on the web, please do the following:"
	einfo "1. Execute the command:"
	einfo " \"ebuild /var/db/pkg/net-misc/${PF}/${PF}.ebuild config\""
	einfo " 2. Edit /etc/conf.d/apache and add \"-D NAGIOS\""
	einfo
	einfo "That will make nagios's web front end visable via"
	einfo "http://localhost/nagios/"
	einfo
	einfo "The Apache config file for nagios will be in"
	einfo "/etc/apache/conf/addon-modules/ with the name of"
	einfo "nagios.conf."
	einfo "Also, if your kernel has /proc protection, nagios"
	einfo "will not be happy as it relies on accessing the proc"
	einfo "filesystem."
	einfo
}


