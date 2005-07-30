# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/neutrino/neutrino-0.8.3.ebuild,v 1.1 2005/07/30 15:14:15 chainsaw Exp $

IUSE=""

DESCRIPTION="A GNOME application to manage Creative music players using the PDE protocol"
HOMEPAGE="http://neutrino.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND="=media-libs/libnjb-2.1.2
	>=media-libs/id3lib-3.8.2
	>=gnome-base/gconf-2
	>=gnome-base/gnome-vfs-2.0
	>=gnome-base/libbonobo-2.0
	>=gnome-base/libgnomecanvas-2.0
	>=dev-libs/glib-2.0.0
	dev-libs/popt
	dev-lang/perl"

RDEPEND="${DEPEND}
	>=dev-util/pkgconfig-0.12.0
	>=dev-util/intltool-0.30"

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
