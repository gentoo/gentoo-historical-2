# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/drivel/drivel-0.9.3.ebuild,v 1.5 2004/06/24 23:42:01 agriffis Exp $

inherit gnome2

DESCRIPTION="Drivel is a LiveJournal client for the GNOME desktop."
HOMEPAGE="http://sourceforge.net/project/drivel/"
SRC_URI="mirror://sourceforge/drivel/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"

RDEPEND=">=x11-libs/gtk+-2.0.0
	>=gnome-base/libgnomeui-2.0.3
	>=gnome-base/gconf-1.2.1
	>=net-misc/curl-7.10"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	dev-util/intltool"

DOCS="AUTHORS ChangeLog INSTALL NEWS README"

src_unpack() {
	unpack ${A}

	sed -e 's/-DGTK_DISABLE_DEPRECATED//g' -i ${S}/src/Makefile.in
	sed -e 's/-DGNOME_DISABLE_DEPRECATED//g' -i ${S}/src/Makefile.in

	cd ${S}
	intltoolize --force
}
