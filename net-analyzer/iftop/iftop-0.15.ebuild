# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/iftop/iftop-0.15.ebuild,v 1.2 2004/06/24 22:04:25 agriffis Exp $

IUSE=""

DESCRIPTION="display bandwidth usage on an interface"
SRC_URI="http://www.ex-parrot.com/~pdw/iftop/download/${P}.tar.gz"
HOMEPAGE="http://www.ex-parrot.com/~pdw/iftop/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

DEPEND="sys-libs/ncurses
		net-libs/libpcap"


src_compile() {
	local myconf
	myconf="--prefix=/usr"
	econf ${myconf} || die
	emake
}

src_install() {
	dosbin iftop
	doman iftop.8

	insinto /etc
	doins ${FILESDIR}/iftoprc

	dodoc COPYING ChangeLog README
}

