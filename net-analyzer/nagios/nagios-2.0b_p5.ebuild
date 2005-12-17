# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nagios/nagios-2.0b_p5.ebuild,v 1.2 2005/12/17 21:19:21 corsair Exp $

DESCRIPTION="The Nagios metapackage - merge this to pull install all of the
nagios packages"
HOMEPAGE="http://www.nagios.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="~net-analyzer/nagios-core-${PV}
	>=net-analyzer/nagios-plugins-1.4
	>=net-analyzer/nagios-nrpe-1.8
	>=net-analyzer/nagios-nsca-2.3
	=net-analyzer/nagios-imagepack-1.0"

pkg_postrm() {
	einfo "Note: this is a META ebuild for ${P}."
	einfo "to remove it completely or before re-emerging"
	einfo "either use 'depclean', or remove/re-emerge these packages:"
	echo
	for dep in ${RDEPEND}; do
		einfo "     ${dep}"
	done
	echo
}

