# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/offlineimap/offlineimap-6.2.0.ebuild,v 1.3 2009/11/08 20:13:46 nixnut Exp $

EAPI=2

inherit distutils

S="${WORKDIR}/${PN}"
DESCRIPTION="Powerful IMAP/Maildir synchronization and reader support"
SRC_URI="mirror://debian/pool/main/o/offlineimap/${P/-/_}.tar.gz"
HOMEPAGE="http://software.complete.org/offlineimap"
LICENSE="GPL-2"
IUSE="ssl"
KEYWORDS="~alpha amd64 ~ia64 ppc x86"
SLOT="0"

DEPEND=""
RDEPEND="dev-lang/python[threads]
	ssl? ( dev-lang/python[ssl] ) "

src_install() {
	distutils_src_install
	dodoc offlineimap.conf offlineimap.conf.minimal offlineimap.sgml
}

pkg_postinst() {
	elog ""
	elog "You will need to configure offlineimap by creating ~/.offlineimaprc"
	elog "Sample configurations are in /usr/share/doc/${P}/"
	elog ""
}
