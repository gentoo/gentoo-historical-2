# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libdv/libdv-0.99-r1.ebuild,v 1.14 2005/01/11 02:44:46 malc Exp $

inherit eutils

DESCRIPTION="Software codec for dv-format video (camcorders etc)."
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://libdv.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ppc sparc alpha hppa"
IUSE="debug gtk sdl xv"

RDEPEND="dev-libs/popt
	gtk? ( =x11-libs/gtk+-1.2* )
	sdl? ( >=media-libs/libsdl-1.2.4.20020601 )
	xv? ( virtual/x11 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A} && cd "${S}"
	epatch "${FILESDIR}/${P}-disablegtk.patch"
	epatch "${FILESDIR}/${P}-2.6.patch"
}

src_compile() {
	local myconf
	myconf="${myconf} `use_with debug`"
	myconf="${myconf} `use_enable gtk` `use_enable gtk gtktest`"
	myconf="${myconf} `use_enable sdl`"
	myconf="${myconf} `use_enable xv`"

	unset CFLAGS CXXFLAGS

	econf ${myconf} || die "econf failed"
	make || die "compile problem"
}

src_install () {
	einstall
	dodoc AUTHORS COPYING COPYRIGHT ChangeLog INSTALL NEWS README* TODO
}
