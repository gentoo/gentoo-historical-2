# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/iftop/iftop-0.16.ebuild,v 1.11 2005/07/09 23:15:23 slarti Exp $

inherit gnuconfig
IUSE=""

DESCRIPTION="display bandwidth usage on an interface"
SRC_URI="http://www.ex-parrot.com/~pdw/iftop/download/${P}.tar.gz"
HOMEPAGE="http://www.ex-parrot.com/~pdw/iftop/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha amd64 ~ia64 sparc x86"

DEPEND="sys-libs/ncurses
		virtual/libpcap"


src_unpack() {
	unpack ${A}
	gnuconfig_update ${S}/config
}

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

