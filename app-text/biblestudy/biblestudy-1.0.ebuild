# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/biblestudy/biblestudy-1.0.ebuild,v 1.2 2004/05/03 22:20:11 squinky86 Exp $

IUSE="unicode"
DESCRIPTION="biblestudy software based on the sword library"
HOMEPAGE="http://www.whensdinner.com/"
SRC_URI="mirror://sourceforge/christiangame/${P}.tar.bz2"
RESTRICT="nomirror"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
newdepend ">=app-text/sword-1.5.7
	>=app-text/sword-modules-20040503
	>=x11-libs/wxGTK-2.4.2"

src_install() {
	make DESTDIR=${D} install || die "install failed"
}

pkg_postinst() {
	if ! use unicode; then
		ewarn
		ewarn "You do not have unicode support enabled. This means that wxWindows"
		ewarn "was probably not built with unicode support. This can cause some"
		ewarn "warnings in biblestudy, though the software is still useable."
		ewarn
	fi
}
