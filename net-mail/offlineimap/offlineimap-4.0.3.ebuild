# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/offlineimap/offlineimap-4.0.3.ebuild,v 1.3 2004/06/24 23:26:06 agriffis Exp $

inherit distutils

S=${WORKDIR}/${PN}
DESCRIPTION="Powerful IMAP/Maildir synchronization and reader support"
SRC_URI="http://gopher.quux.org:70/devel/offlineimap/offlineimap_${PV}.tar.gz"
HOMEPAGE="http://gopher.quux.org:70/devel/offlineimap"
LICENSE="GPL-2"
IUSE=""
KEYWORDS="~x86 ~alpha ~ia64 ~amd64 ~ppc"
SLOT="0"

DEPEND=""

src_install() {
	distutils_src_install
	dodoc offlineimap.conf offlineimap.conf.minimal offlineimap.sgml
	doman offlineimap.1
}

pkg_postinst() {
	einfo ""
	einfo "You will need to configure offlineimap by creating ~/.offlineimaprc"
	einfo "Sample configurations are in /usr/share/doc/${P}/"
	einfo ""
}
