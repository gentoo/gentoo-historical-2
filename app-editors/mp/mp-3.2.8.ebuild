# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/mp/mp-3.2.8.ebuild,v 1.7 2004/06/24 21:59:23 agriffis Exp $

DESCRIPTION="the definitive text editor"
HOMEPAGE="http://www.triptico.com/software/mp.html"
SRC_URI="http://www.triptico.com/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~sparc ~amd64"
IUSE="ncurses gtk"

DEPEND="virtual/glibc
	ncurses? ( sys-libs/ncurses )
	gtk? ( =x11-libs/gtk+-1.2* )
	!gtk? ( sys-libs/ncurses )"
RDEPEND="${DEPEND}
	dev-lang/perl"

src_compile() {
	if use ncurses && use gtk ; then
		emake || die
	elif use ncurses || ! use gtk ; then
		emake mp || die
	elif use gtk ; then
		emake gmp || die
	fi
}

src_install() {
	dodir /usr/bin
	make install PREFIX=${D}/usr || die "install failed"
	dodoc AUTHORS Changelog README
	dohtml README.html doc/mp_api.html
}
