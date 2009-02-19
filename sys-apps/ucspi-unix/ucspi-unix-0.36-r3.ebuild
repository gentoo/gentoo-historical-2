# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/ucspi-unix/ucspi-unix-0.36-r3.ebuild,v 1.4 2009/02/19 18:27:46 nixnut Exp $

inherit eutils toolchain-funcs

DESCRIPTION="A ucspi implementation for unix sockets"
HOMEPAGE="http://untroubled.org/ucspi-unix/"
SRC_URI="http://untroubled.org/ucspi-unix/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE=""

DEPEND=">=dev-libs/bglibs-1.019-r1"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-gentoo-head.patch
	epatch "${FILESDIR}"/${P}-include-sys_socket.h.patch
}

src_compile() {
	use kernel_linux && PEERCRED="-DHASPEERCRED=1"
	echo "$(tc-getCC) ${CFLAGS} -I/usr/lib/bglibs/include ${PEERCRED} -D_GNU_SOURCE" > conf-cc
	echo "$(tc-getCC) ${LDFLAGS} -L/usr/lib/bglibs/lib" > conf-ld
	make || die  #don't use emake b/c of jobserver
}

src_install() {
	dobin unixserver unixclient unixcat || die
	doman unixserver.1 unixclient.1
	dodoc ANNOUNCEMENT NEWS PROTOCOL README TODO
}
