# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/gnome-online-miners/gnome-online-miners-3.10.2.ebuild,v 1.1 2013/12/24 16:54:05 pacho Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Crawls through your online content"
HOMEPAGE="https://git.gnome.org/browse/gnome-online-miners"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""
KEYWORDS="~amd64"

RDEPEND="
	>=dev-libs/libgdata-0.13.3:0=
	>=dev-libs/glib-2.35.1:2
	>=net-libs/gnome-online-accounts-3.2.0
	>=media-libs/grilo-0.2.6:0.2
	>=net-libs/libzapojit-0.0.2
	>=app-misc/tracker-0.16:0=
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--docdir="${EPREFIX}"/usr/share/doc/${P}
}
