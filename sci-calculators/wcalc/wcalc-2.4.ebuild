# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-calculators/wcalc/wcalc-2.4.ebuild,v 1.2 2009/05/29 17:02:33 beandog Exp $

inherit eutils

DESCRIPTION="A flexible command-line scientific calculator"
HOMEPAGE="http://w-calc.sourceforge.net"
SRC_URI="mirror://sourceforge/w-calc/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE="readline"

DEPEND="readline? ( sys-libs/readline )
	dev-libs/mpfr
	dev-libs/gmp"

src_compile() {
	econf $(use_with readline)
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README || die

	# Wcalc icons
	newicon w.png wcalc.png || die
	newicon Wred.png wcalc-red.png || die
}
