# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/offlineimap/offlineimap-4.0.13.ebuild,v 1.7 2008/02/03 14:32:51 grobian Exp $

inherit distutils

S=${WORKDIR}/${PN}
DESCRIPTION="Powerful IMAP/Maildir synchronization and reader support"
SRC_URI="mirror://debian/pool/main/o/offlineimap/${P/-/_}.tar.gz"
HOMEPAGE="http://software.complete.org/offlineimap"
LICENSE="GPL-2"
IUSE=""
KEYWORDS="alpha amd64 ia64 ppc ~x86"
SLOT="0"

DEPEND=""

src_install() {
	distutils_src_install
	dodoc offlineimap.conf offlineimap.conf.minimal offlineimap.sgml
	doman offlineimap.1
}

pkg_postinst() {
	elog ""
	elog "You will need to configure offlineimap by creating ~/.offlineimaprc"
	elog "Sample configurations are in /usr/share/doc/${P}/"
	elog ""
}
