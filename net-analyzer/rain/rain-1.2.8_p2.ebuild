# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/rain/rain-1.2.8_p2.ebuild,v 1.2 2004/06/24 22:16:38 agriffis Exp $

MY_P=${P/_p/r}
S=${WORKDIR}/${MY_P}
DESCRIPTION="powerful tool for testing stability of hardware and software utilizing IP protocols"
HOMEPAGE="http://www.mirrors.wiretapped.net/security/packet-construction/rain/"
SRC_URI="http://www.mirrors.wiretapped.net/security/packet-construction/rain/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND=""

src_unpack() {
	unpack ${A}
	sed -i 's:-g:@CFLAGS@:' ${S}/Makefile.in
}

src_install() {
	dosbin rain
	doman man/rain.1.gz
	dodoc BUGS CHANGES README TODO
}
