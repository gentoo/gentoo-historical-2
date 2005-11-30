# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmappl/wmappl-0.71.ebuild,v 1.1.1.1 2005/11/30 10:10:56 chriswhite Exp $

IUSE=""
DESCRIPTION="Simple application launcher for the Window Maker dock."
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://wmappl.sourceforge.net/"

DEPEND="virtual/x11"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc amd64 ppc"

src_compile() {
	econf || die "Configuration failed"
	emake || die "Compilation failed"
}

src_install () {
	einstall || die "Installation failed"
}
