## Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/media-libs/aalib/aalib-1.4_rc4-r2.ebuild,v 1.3 2002/07/22 14:37:05 seemant Exp $

inherit libtool

MY_P=${P/_/}
S=${WORKDIR}/${PN}-1.4.0
DESCRIPTION="A ASCI-Graphics Library"
SRC_URI="mirror://sourceforge/aa-project/${MY_P}.tar.gz"
HOMEPAGE="http://aa-project.sourceforge.net/aalib/"

DEPEND=">=sys-libs/ncurses-5.1
	X?	 ( virtual/x11 )
	gpm?   ( sys-libs/gpm )
	slang? ( >=sys-libs/slang-1.4.2 )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc"

src_unpack() {

	unpack ${A}
	patch -p0 < ${FILESDIR}/${P}-gentoo.diff || die
	touch *
}

src_compile() {

	local myconf
	use slang \
		&& myconf="--with-slang-driver=yes" \
		|| myconf="--with-slang-driver=no"
	
	use X \
		&& myconf="${myconf} --with-x11-driver=yes" \
		|| myconf="${myconf} --with-x11-driver=no"
	
	use gpm \
		&& myconf="${myconf} --with-gpm-mouse=no"

	elibtoolize

	econf ${myconf} || die
	emake || die
}

src_install() {

	einstall || die
	dodoc ANNOUNCE AUTHORS ChangeLog COPYING NEWS README*
}
