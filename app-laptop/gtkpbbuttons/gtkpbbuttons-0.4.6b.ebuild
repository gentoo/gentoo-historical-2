# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-laptop/gtkpbbuttons/gtkpbbuttons-0.4.6b.ebuild,v 1.4 2004/06/24 21:58:04 agriffis Exp $

DESCRIPTION="PPC-only program to monitor special Powerbook/iBook keys in Linux"
HOMEPAGE="http://www.cymes.de/members/joker/projects/pbbuttons/pbbuttons.html"
SRC_URI="http://www.cymes.de/members/joker/projects/pbbuttons/tar/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ppc"
IUSE=""

DEPEND="=x11-libs/gtk+-1.2*
	media-libs/audiofile
	>=app-laptop/pbbuttonsd-0.5"

src_compile() {
	econf || die
	make || die "compile failed"
}

src_install() {
	make install DESTDIR=${D} || die
	dodoc README COPYING
}
