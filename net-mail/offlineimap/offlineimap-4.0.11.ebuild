# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/offlineimap/offlineimap-4.0.11.ebuild,v 1.1 2005/09/06 00:16:27 ferdy Exp $

inherit distutils

S=${WORKDIR}/${PN}
DESCRIPTION="Powerful IMAP/Maildir synchronization and reader support"
SRC_URI="http://ftp.debian.org/debian/pool/main/o/offlineimap/${P/-/_}.tar.gz"
HOMEPAGE="http://gopher.quux.org:70/devel/offlineimap"
LICENSE="GPL-2"
IUSE=""
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~x86"
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
