# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/iftop/iftop-0.11.ebuild,v 1.2 2003/02/13 20:15:53 vapier Exp $

IUSE=""

S=${WORKDIR}/${P}
DESCRIPTION="display bandwidth usage on an interface"
SRC_URI="http://www.ex-parrot.com/~pdw/iftop/download/${P}.tar.gz"
HOMEPAGE="http://www.ex-parrot.com/~pdw/iftop/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

DEPEND="sys-libs/ncurses
	net-libs/libpcap"

src_compile() {
	econf || die
	emake || die
}

src_install() {
	dosbin iftop
	doman iftop.8
	dodoc COPYING CHANGES README
}

