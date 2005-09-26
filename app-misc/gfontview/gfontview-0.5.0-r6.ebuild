# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/gfontview/gfontview-0.5.0-r6.ebuild,v 1.11 2005/09/26 16:09:11 dang Exp $

inherit eutils

DESCRIPTION="Fontviewer for PostScript Type 1 and TrueType"
HOMEPAGE="http://gfontview.sourceforge.net/"
SRC_URI="mirror://sourceforge/gfontview/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc amd64"
IUSE="nls gnome"

DEPEND=">=media-libs/t1lib-1.0.1
	=media-libs/freetype-1*
	=x11-libs/gtk+-1.2*
	media-libs/giflib
	gnome? ( >=gnome-base/gnome-libs-1.4.1.2-r1 )
	virtual/lpr"
RDEPEND="nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${P}.tar.gz
	cd ${S}
	epatch ${FILESDIR}/${P}-gcc-34.patch.gz
}

src_compile() {
	local myconf
	use nls || myconf="--disable-nls"
	econf ${myconf} || die "econf failed"
	make || die
}

src_install() {
	einstall
	dodoc AUTHORS ChangeLog NEWS README TODO
	insinto /usr/X11R6/include/X11/pixmaps/
	doins error.xpm openhand.xpm font.xpm t1.xpm tt.xpm
}
