# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/orsa/orsa-0.3.1.ebuild,v 1.4 2004/04/19 12:02:34 phosphan Exp $

inherit base flag-o-matic

DESCRIPTION="Orbit Reconstruction, Simulation and Analysis"
HOMEPAGE="http://orsa.sourceforge.net/"
SRC_URI="mirror://sourceforge/orsa/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="x86"

DEPEND="virtual/glibc
	dev-libs/fftw
	dev-libs/gsl
	x11-libs/qt
	sys-libs/readline"

replace-flags k6-3 i586
replace-flags k6-2 i586
replace-flags k6 i586

src_compile() {
	econf || die "configure failed"
	emake || die
}

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog INSTALL NEWS README THANKS
}
