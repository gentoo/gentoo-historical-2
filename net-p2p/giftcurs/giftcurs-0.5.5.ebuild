# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/giftcurs/giftcurs-0.5.5.ebuild,v 1.6 2003/02/13 15:19:01 vapier Exp $

MY_P="giFTcurs-${PV}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="A cursed frontend to the giFT (OpenFT) daemon"
SRC_URI="mirror://sourceforge/giftcurs/${MY_P}.tar.gz"
HOMEPAGE="http://giftcurs.sourceforge.net/"
SLOT="0"
LICENSE="GPL-2"
IUSE="gpm nls"
KEYWORDS="x86 sparc ~ppc"

DEPEND="virtual/glibc
	>=sys-libs/ncurses-5.2
	>=net-p2p/gift-cvs-0.10.0"

src_compile() {
	local myconf=""
	
	use gpm || myconf="${myconf} --disable-mouse --disable-libgpm"
	use nls || myconf="${myconf} --disable-nls" 

	econf $myconf || die "./configure failed"
	
	emake || die "Compilation failed"
}

src_install() {
	einstall || die "Installation failed"
	
	dodoc ABOUT-NLS AUTHORS COPYING ChangeLog NEWS README THANKS TODO
}
