# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/xprobe/xprobe-0.0.2.ebuild,v 1.6 2004/06/24 22:23:59 agriffis Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Active OS fingerprinting tool"
SRC_URI="http://www.sys-security.com/archive/tools/X/${P}.tar.gz"
HOMEPAGE="http://www.sys-security.com/html/projects/X.html"
KEYWORDS="x86 ~sparc"
SLOT="0"
LICENSE="GPL-2"

DEPEND=">=net-libs/libpcap-0.6.1"

src_unpack() {
	unpack ${A}

	cd ${S}
	patch -p0 < ${FILESDIR}/${P}-gentoo.patch || die
}

src_compile() {
	econf || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS CREDITS LICENSE
	dodoc Changelog TODO README
}

