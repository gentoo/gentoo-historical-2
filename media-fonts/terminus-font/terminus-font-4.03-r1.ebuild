# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/terminus-font/terminus-font-4.03-r1.ebuild,v 1.1 2003/09/26 05:17:28 mkennedy Exp $

DESCRIPTION="A clean fixed font for the console and X11"
HOMEPAGE="http://www.is-vn.bg/hamster/jimmy-en.htm"
SRC_URI="http://www.is-vn.bg/hamster/${P}.tar.gz
	http://www.is-vn.bg/hamster/courier-like-a.diff.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="X"

DEPEND="sys-apps/gawk
	dev-lang/perl
	X? ( virtual/x11 )"
RDEPEND="X? ( virtual/x11 )"

src_unpack() {
	unpack ${A}
	# upstream author's own patch for courier like a (to be included
	# by default in future releases of terminus-font)
	epatch courier-like-a.diff
}

src_compile() {
	./configure \
	    --prefix=${D}/usr \
	    --psfdir=${D}/usr/share/consolefonts \
	    --acmdir=${D}/usr/share/consoletrans \
	    --unidir=${D}/usr/share/consoletrans \
	    --x11dir=${D}/usr/share/fonts/terminus

	make psf txt || die

	# If user wants fonts for X11
	if [ -n "`use X`" ]; then
		make pcf || die
	fi
}

src_install() {
	make install-psf install-acm install-uni install-ref || die

	# If user wants fonts for X11
	if [ -n "`use X`" ]; then
		make install-pcf || die
	fi

	dodoc README*
}
