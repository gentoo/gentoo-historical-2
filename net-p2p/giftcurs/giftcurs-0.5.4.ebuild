# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/giftcurs/giftcurs-0.5.4.ebuild,v 1.3 2002/11/29 12:50:41 verwilst Exp $

MY_P="giFTcurs-${PV}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="A cursed frontend to the giFT (OpenFT) daemon"
SRC_URI="mirror://sourceforge/giftcurs/${MY_P}.tar.gz"
HOMEPAGE="http://giftcurs.sourceforge.net/"
SLOT="0"
LICENSE="GPL-2"
IUSE="gpm nls"
KEYWORDS="x86 ~sparc ~sparc64"

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
