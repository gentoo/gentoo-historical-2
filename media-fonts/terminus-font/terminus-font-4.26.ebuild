# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/terminus-font/terminus-font-4.26.ebuild,v 1.4 2008/06/16 06:04:11 josejx Exp $

DESCRIPTION="A clean fixed font for the console and X11"
HOMEPAGE="http://www.is-vn.bg/hamster/jimmy-en.html"
SRC_URI="http://www.is-vn.bg/hamster/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"
IUSE="X"

DEPEND="X? ( x11-apps/bdftopcf )"
RDEPEND=""

src_compile() {
	./configure \
		--prefix=/usr \
		--psfdir=/usr/share/consolefonts \
		--acmdir=/usr/share/consoletrans \
		--unidir=/usr/share/consoletrans \
		--x11dir=/usr/share/fonts/terminus

	emake psf txt || die

	# If user wants fonts for X11
	if use X; then
		emake pcf || die
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
