# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-calculators/galculator/galculator-1.2.3.ebuild,v 1.1 2004/12/24 14:54:42 ribosome Exp $

DESCRIPTION="A GTK2 based algebraic and RPN calculator"
HOMEPAGE="http://galculator.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=">=x11-libs/gtk+-1.3.13
	>=gnome-base/libglade-2"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	econf || die
	emake || die
}

src_install() {
	einstall || die

	dodoc ABOUT-NLS AUTHORS ChangeLog COPYING NEWS README THANKS TODO
}
