# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nagios/nagios-1.1.ebuild,v 1.2 2003/06/17 22:58:35 alron Exp $

DESCRIPTION="Nagios $PV - merge this to pull install all of the nagios packages"
HOMEPAGE="http://www.nagios.org/"
RDEPEND=">=net-analyzer/nagios-core-1.1
		 >=net-analyzer/nagios-plugins-1.3.0
		 >=net-analyzer/nagios-nrpe-1.7
		 >=net-analyzer/nagios-nsca-2.2
		 >=net-analyzer/nagios-imagepack-1.0"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~sparc ~ppc"
pkg_postinst() {
    einfo
    einfo "Remember to edit the config files in /etc/nagios"
    einfo "Also, if you want nagios to start at boot time"
    einfo "remember to execute rc-update add nagios default"
    einfo
    einfo "To have nagios visable on the web, please do the following:"
    if [ "`use apache2`" ] ; then
        einfo "Edit /etc/conf.d/apache2 and add \"-D NAGIOS\""
    else
        einfo "1. Execute the command:"
        einfo " \"ebuild /var/db/pkg/net-analyzer/${PF}/${PF}.ebuild config\""
        einfo " 2. Edit /etc/conf.d/apache and add \"-D NAGIOS\""
    fi
    einfo
    einfo "That will make nagios's web front end visable via"
    einfo "http://localhost/nagios/"
    einfo
    if [ "`use apache2`" ] ; then
        einfo "The Apache2 config file for nagios will be in"
        einfo "/etc/apache2/conf/modules.d with the name of"
        einfo "99_nagios.conf."
    else
        einfo "The Apache config file for nagios will be in"
        einfo "/etc/apache/conf/addon-modules/ with the name of"
        einfo "nagios.conf."
    fi
    einfo "Also, if your kernel has /proc protection, nagios"
    einfo "will not be happy as it relies on accessing the proc"
    einfo "filesystem. You can fix this by adding nagios into"
    einfo "the group wheel, but this is not recomended."
    einfo

}


