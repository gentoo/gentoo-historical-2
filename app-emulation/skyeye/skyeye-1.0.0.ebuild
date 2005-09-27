# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/skyeye/skyeye-1.0.0.ebuild,v 1.1 2005/09/27 02:02:04 vapier Exp $

DESCRIPTION="an ARM embedded hardware simulator"
HOMEPAGE="http://www.skyeye.org/"
SRC_URI="http://download.gro.clinux.org/skyeye/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="virtual/x11
	media-libs/freetype
	>=x11-libs/gtk+-2
	>=dev-libs/glib-2
	x11-libs/pango"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_install() {
	dobin binary/skyeye || die "skyeye"
	dodoc ChangeLog README
}
