# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/fcitx/fcitx-1.8.5.ebuild,v 1.6 2004/06/24 21:45:10 agriffis Exp $

DESCRIPTION="Free Chinese Input Toy for X. Another Chinese XIM Input Method"
HOMEPAGE="http://www.fcitx.org/"
SRC_URI="http://www.fcitx.org/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="truetype"

DEPEND="virtual/x11
	truetype? ( virtual/xft )"

src_compile() {
	if use truetype; then
		make -f Makefile.xft || die "xft make failed"
	else
		make || die "make failed"
	fi
}

src_install() {
	dobin fcitx
	insinto /usr/share/fcitx
	doins data/*.mb

	dodoc doc/ChangLog.txt doc/cjkvinput.txt
	dohtml doc/*.htm
}

