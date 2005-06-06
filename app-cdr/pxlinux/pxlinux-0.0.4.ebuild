# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/pxlinux/pxlinux-0.0.4.ebuild,v 1.1 2005/06/06 22:35:06 vapier Exp $

DESCRIPTION="PlexTools-like app for Plextor drives in linux"
HOMEPAGE="http://www-user.tu-chemnitz.de/~noe/Plextor/"
SRC_URI="http://www-user.tu-chemnitz.de/~noe/Plextor/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnuplot"

RDEPEND="gnuplot? ( dev-lang/python media-gfx/gnuplot )"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm -f Makefile
}

src_compile() {
	emake ta pif pisum8 jitterbeta || die "compile failed"
}

src_install() {
	dobin ta pif pisum8 jitterbeta || die "dobin failed"
	use gnuplot && dobin *.py
	dodoc CHANGELOG
	dohtml -r doc_html/*
}
