# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/gok/gok-0.9.3.ebuild,v 1.7 2004/06/24 21:23:20 agriffis Exp $

inherit eutils gnome2

DESCRIPTION="Gnome Onscreen Keyboard"
HOMEPAGE="http://www.gok.ca/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="x86 ppc -sparc mips ~alpha hppa amd64 ~ia64"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2
	>=gnome-base/libgnomeui-2
	>=gnome-base/libbonobo-2
	>=gnome-base/gconf-2
	>=dev-libs/atk-1.3
	gnome-base/gail
	media-sound/esound
	>=x11-libs/libwnck-1
	>=gnome-extra/at-spi-1.3.4
	virtual/x11"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	app-text/scrollkeeper"

DOCS="AUTHORS ChangeLog NEWS README"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PN}-${PV}-ansi_C.patch
	sed -i 's:$pkgdatadir:/usr/share/gok:' gok-with-references.schemas.m4
}
