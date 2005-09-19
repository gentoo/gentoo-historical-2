# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/connect/connect-1.95.ebuild,v 1.1 2005/09/19 18:02:42 wschlich Exp $

DESCRIPTION="network connection relaying command"
HOMEPAGE="http://zippo.taiyo.co.jp/~gotoh/ssh/connect.html"
SRC_URI="http://dev.gentoo.org/~wschlich/src/net-misc/connect/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
DEPEND="virtual/libc"

src_unpack() {
	unpack ${A}
	cd ${S}
}

src_compile() {
	emake CFLAGS="${CFLAGS}" || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
}

pkg_postinst() {
	einfo
	einfo "There is no manpage, please see ${HOMEPAGE} for details"
	einfo
}
