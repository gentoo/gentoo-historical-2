# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/divx4linux/divx4linux-20020418-r2.ebuild,v 1.5 2003/08/03 02:44:32 vapier Exp $

DXVER="501"
DESCRIPTION="Binary release of DivX Codec 5.0.1"
HOMEPAGE="http://www.divx.com/"
SRC_URI="http://download.divx.com/divx/${PN}${DXVER}-${PV}.tgz"

LICENSE="DIVX"
SLOT="0"
KEYWORDS="-* x86"
RESTRICT="nostrip"

DEPEND="virtual/glibc"

src_install() {
	for lib in *.so ; do
		dolib.so ${lib}
		dosym /usr/lib/${lib} /usr/lib/${lib}.0
	done

	# Fix bug #13776.
	dosed -e 's|c:\\trace_b.txt|/dev/null\x00\x00\x00\x00\x00|' \
		/usr/lib/libdivxencore.so

	insinto /usr/include
	doins *.h

	dodoc README.linux license.txt
	dodir /usr/share/doc/${PF}/html
	cp -a 'DivX MPEG-4 Codec and Its Interface.htm' ${D}/usr/share/doc/${PF}/html
}
