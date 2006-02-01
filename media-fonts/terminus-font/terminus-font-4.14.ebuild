# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/terminus-font/terminus-font-4.14.ebuild,v 1.6 2006/02/01 07:16:11 mr_bones_ Exp $

DESCRIPTION="A clean fixed font for the console and X11"
HOMEPAGE="http://www.is-vn.bg/hamster/jimmy-en.html"
SRC_URI="http://www.is-vn.bg/hamster/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE="X"

DEPEND="sys-apps/gawk
		dev-lang/perl
		X? ( || ( x11-apps/bdftopcf virtual/x11 ) )"
RDEPEND=""

src_compile() {
	./configure \
		--prefix=/usr \
		--psfdir=/usr/share/consolefonts \
		--acmdir=/usr/share/consoletrans \
		--unidir=/usr/share/consoletrans \
		--x11dir=/usr/share/fonts/terminus

	make psf txt || die

	# If user wants fonts for X11
	if use X; then
		make pcf || die
	fi
}

src_install() {
	make DESTDIR=${D} install-psf install-acm install-ref || die

	# If user wants fonts for X11
	if use X; then
		make DESTDIR=${D} install-pcf || die
		mkfontdir ${D}/usr/share/fonts/terminus
	fi

	dodoc README*
}
