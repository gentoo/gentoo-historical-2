# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/drivel/drivel-1.0.2.ebuild,v 1.6 2005/02/03 01:33:46 joem Exp $

inherit gnome2

DESCRIPTION="Drivel is a LiveJournal client for the GNOME desktop."
HOMEPAGE="http://www.dropline.net/drivel/"
SRC_URI="mirror://sourceforge/drivel/${P}.tar.bz2"
LICENSE="GPL-2"

IUSE=""
SLOT="0"
KEYWORDS="x86 ~ppc"

RDEPEND=">=dev-libs/glib-2.4
	>=x11-libs/gtk+-2.4
	>=gnome-base/gconf-2
	>=gnome-base/gnome-vfs-2.6
	>=gnome-base/libgnomeui-2.0.3
	>=gnome-base/libglade-2
	>=net-misc/curl-7.10"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	dev-util/intltool"

DOCS="AUTHORS ChangeLog INSTALL NEWS README TODO"

src_unpack() {
	unpack ${A}

	sed -e 's/-DGTK_DISABLE_DEPRECATED//g' -i ${S}/src/Makefile.in
	sed -e 's/-DGNOME_DISABLE_DEPRECATED//g' -i ${S}/src/Makefile.in

}
