# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libdv/libdv-0.102.ebuild,v 1.12 2005/07/09 01:29:58 vapier Exp $

inherit eutils

DESCRIPTION="Software codec for dv-format video (camcorders etc)."
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://libdv.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE="debug gtk sdl xv"

RDEPEND="dev-libs/popt
	gtk? ( =x11-libs/gtk+-1.2* )
	sdl? ( >=media-libs/libsdl-1.2.4.20020601 )
	xv? ( virtual/x11 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A} && cd "${S}"
	epatch "${FILESDIR}/${PN}-0.99-2.6.patch"
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
