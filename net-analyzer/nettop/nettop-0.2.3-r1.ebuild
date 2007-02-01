# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nettop/nettop-0.2.3-r1.ebuild,v 1.1 2007/02/01 19:17:45 jokey Exp $

inherit eutils

IUSE=""

DESCRIPTION="top like program for network activity"
SRC_URI="http://srparish.net/scripts/${P}.tar.gz"
HOMEPAGE="http://srparish.net/software/"

SLOT="0"
LICENSE="BSD"
KEYWORDS="amd64 ppc sparc x86"

DEPEND="=sys-libs/slang-1*
	net-libs/libpcap"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gcc411.patch
	epatch "${FILESDIR}"/${P}-offbyone.patch
}

src_compile() {
	local myconf
	myconf="--prefix=/usr"
	./configure ${myconf} || die "configure failed"
	emake || die "emake failed"
}

src_install() {
	dosbin nettop
	dodoc ChangeLog README THANKS
}
