# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-calculators/galculator/galculator-1.3.4.ebuild,v 1.2 2009/12/19 12:42:00 pacho Exp $

EAPI="2"

DESCRIPTION="GTK+ based algebraic and RPN calculator."
HOMEPAGE="http://galculator.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~alpha amd64 ~ppc ~x86 ~x86-fbsd"
IUSE="gnome"

RDEPEND=">=x11-libs/gtk+-2.6
	>=gnome-base/libglade-2
	gnome? ( gnome-base/gnome-desktop )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	use gnome || sed -i -e 's:gnome-calc2.png:calc:' "${S}"/galculator.desktop.in
	# Fix tests
	echo ui/*.glade | tr -t ' ' '\n' >> po/POTFILES.in
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO || die "dodoc failed"
}
