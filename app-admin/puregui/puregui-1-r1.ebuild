# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/puregui/puregui-1-r1.ebuild,v 1.10 2002/10/18 13:31:45 aliz Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A GUI to Configure Pure-FTPD"
SRC_URI="mirror://sourceforge/pureftpd/${PN}.tar.gz"
HOMEPAGE="http://pureftpd.sourceforge.net"
IUSE=""

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc sparc64"

DEPEND="=x11-libs/gtk+-1.2*"

src_compile() {

	econf \
		--cache-file=${FILESDIR}/config.cache || die
	make || die

}

src_install () {

	make DESTDIR=${D} install || die
	dodoc COPYING ChangeLog README

}
