# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nessus/nessus-2.2.6.ebuild,v 1.7 2006/02/07 21:31:05 blubb Exp $

DESCRIPTION="A remote security scanner for Linux"
HOMEPAGE="http://www.nessus.org/"
DEPEND="~net-analyzer/nessus-libraries-${PV}
	~net-analyzer/libnasl-${PV}
	~net-analyzer/nessus-core-${PV}
	~net-analyzer/nessus-plugins-${PV}"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
IUSE=""

pkg_postinst() {
	einfo "The following article may be useful to get started:"
	einfo "http://www.securityfocus.com/infocus/1741"
}

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

