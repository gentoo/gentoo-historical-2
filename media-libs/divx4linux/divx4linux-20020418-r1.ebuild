# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/divx4linux/divx4linux-20020418-r1.ebuild,v 1.10 2004/07/14 19:18:45 agriffis Exp $

DXVER="501"
DESCRIPTION="Binary release of DivX Codec 5.0.1"
HOMEPAGE="http://www.divx.com/"
SRC_URI="http://download.divx.com/divx/${PN}${DXVER}-${PV}.tgz"

LICENSE="DIVX"
SLOT="0"
KEYWORDS="-* x86"
IUSE=""
RESTRICT="nostrip"

DEPEND="virtual/libc"

src_install() {
	for lib in *.so ; do
		dolib.so ${lib}
		dosym /usr/lib/${lib} /usr/lib/${lib}.0
	done

	insinto /usr/include
	doins *.h

	dodoc README.linux license.txt
	dodir /usr/share/doc/${PF}/html
	cp -a 'DivX MPEG-4 Codec and Its Interface.htm' ${D}/usr/share/doc/${PF}/html
}
