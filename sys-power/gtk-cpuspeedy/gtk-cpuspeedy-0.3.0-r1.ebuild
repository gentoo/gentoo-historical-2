# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/gtk-cpuspeedy/gtk-cpuspeedy-0.3.0-r1.ebuild,v 1.3 2006/10/29 08:22:57 dragonheart Exp $

DESCRIPTION="Graphical GTK+-2 frontend for cpuspeedy"
HOMEPAGE="http://cpuspeedy.sourceforge.net/"
SRC_URI="mirror://sourceforge/cpuspeedy/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc x86"
IUSE=""

DEPEND="
	sys-apps/texinfo
	dev-util/pkgconfig
	dev-libs/glib
	dev-libs/atk
	x11-libs/pango
	media-libs/fontconfig
	media-libs/freetype
	dev-libs/expat
	>=x11-libs/gtk+-2
	x11-libs/cairo"
RDEPEND=">=sys-power/cpuspeedy-0.2
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib
	media-libs/fontconfig
	media-libs/freetype
	x11-libs/gtk+
	x11-libs/pango
	x11-libs/gksu
	x11-libs/cairo"

src_install() {
	einstall || die "einstall failed"
	dodoc AUTHORS ChangeLog README TODO
}
