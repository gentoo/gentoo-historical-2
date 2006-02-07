# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/flpsed/flpsed-0.3.2.ebuild,v 1.3 2006/02/07 17:36:44 nattfodd Exp $

inherit flag-o-matic

DESCRIPTION="a pseudo PostScript editor"
HOMEPAGE="http://www.ecademix.com/JohannesHofmann/"
SRC_URI="http://www.ecademix.com/JohannesHofmann/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

RDEPEND="|| ( ( x11-libs/libX11
			    x11-libs/libXext
				x11-libs/libXft
			  )
			  virtual/x11
			)"
DEPEND="${RDEPEND}
	>=x11-libs/fltk-1.1
	virtual/ghostscript"

src_compile() {
	append-flags $(fltk-config --cxxflags)
	append-ldflags $(fltk-config --ldflags)

	emake -f ${FILESDIR}/Makefile-0.3 || die "emake failed"
}

src_install() {
	dobin flpsed
	dodoc README ChangeLog
}
