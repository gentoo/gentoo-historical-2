# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/w3mimgfb/w3mimgfb-0.8.ebuild,v 1.6 2004/06/24 22:51:43 agriffis Exp $

inherit gcc

DESCRIPTION="Image viewer for w3m under frame buffer environment"
HOMEPAGE="http://homepage3.nifty.com/slokar/fb/w3mimg.html"
SRC_URI="http://homepage3.nifty.com/slokar/fb/${P}.tar.gz"

LICENSE="w3m BSD"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND=">=media-libs/stimg-0.1.0
	virtual/textbrowser"

src_compile() {
	emake CC="$(gcc-getCC)" CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {

	local realbin

	if has_version '<net-www/w3m-0.4.2' ; then
		exeinto /usr/lib/w3m
		doexe w3mimgdisplayfb
	elif has_version '>=net-www/w3m-0.4.2-r1' ; then
		exeinto /usr/libexec/w3m
		doexe w3mimgdisplayfb
	fi
	if has_version '<net-www/w3m-m17n-0.4.2' ; then
		exeinto /usr/lib/w3m-m17n
		doexe w3mimgdisplayfb
	elif has_version '>=net-www/w3m-m17n-0.4.2' ; then
		exeinto /usr/libexec/w3m-m17n
		doexe w3mimgdisplayfb
	fi

	for exe in /usr/lib{,exec}/w3m{,-m17n}/w3mimgdisplayfb ; do
		if [ -n "$realexe" ] ; then
			rm ${D}$exe
			dohard $realexe $exe
		elif [ -x ${D}$exe ] ; then
			realexe=$exe
		fi
	done

	dodoc COPYING readme.txt
}
