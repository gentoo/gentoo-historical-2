# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/mbrowse/mbrowse-0.3.1.ebuild,v 1.3 2004/07/10 11:49:48 eldad Exp $

DESCRIPTION="MBrowse is a graphical MIB browser"
HOMEPAGE="http://www.kill-9.org/mbrowse/index.html"
SRC_URI="http://www.kill-9.org/mbrowse/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="virtual/snmp
	>=x11-libs/gtk+-1.2.10"

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"

	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc AUTHORS README ChangeLog
}
