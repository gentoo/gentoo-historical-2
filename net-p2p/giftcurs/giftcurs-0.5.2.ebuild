# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/giftcurs/giftcurs-0.5.2.ebuild,v 1.6 2002/12/09 04:33:19 manson Exp $

S="${WORKDIR}/giFTcurs-${PV}"
DESCRIPTION="a cursed frontend to the giFT (OpenFT) daemon"
SRC_URI="mirror://sourceforge/giftcurs/giFTcurs-${PV}.tar.gz"
HOMEPAGE="http://giftcurs.sourceforge.net"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc "

DEPEND="virtual/glibc
	>=sys-libs/ncurses-5.2
	>=net-p2p/gift-0.10.0_pre020705"

src_compile() {
	local myconf
	cd ${S}
	use gpm || myconf="${myconf} --disable-mouse --disable-libgpm"
	use nls || myconf="${myconf} --disable-nls" 
	./configure --prefix=/usr --host=${CHOST} ${myconf}
	emake || die
}

src_install() {

	einstall || die
	dodoc ABOUT-NLS  AUTHORS COPYING ChangeLog INSTALL NEWS README TODO
}
