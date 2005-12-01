# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/flpsed/flpsed-0.3.5.ebuild,v 1.1 2005/12/01 17:44:39 nattfodd Exp $

inherit flag-o-matic

DESCRIPTION="Pseudo PostScript editor"
HOMEPAGE="http://www.ecademix.com/JohannesHofmann/"
SRC_URI="http://www.ecademix.com/JohannesHofmann/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="virtual/x11
	>=x11-libs/fltk-1.1
	virtual/ghostscript"

src_compile() {
	append-flags $(fltk-config --cxxflags)
	append-ldflags $(fltk-config --ldflags)

	econf || die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc README ChangeLog NEWS
}
