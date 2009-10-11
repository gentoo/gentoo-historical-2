# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/at-poke/at-poke-0.2.2.ebuild,v 1.10 2009/10/11 21:16:59 halcy0n Exp $

inherit eutils gnome2

DESCRIPTION="The accessibility poking tool"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~ppc sparc x86"
IUSE=""

RDEPEND=">=gnome-extra/at-spi-1.3.12
	>=gnome-base/libglade-2
	>=x11-libs/gtk+-2
	>=gnome-base/libgnomeui-2
	gnome-extra/libgail-gnome
	>=dev-libs/popt-1.5"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9"

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="--enable-platform-gnome-2"
}

src_unpack() {
	gnome2_src_unpack

	epatch "${FILESDIR}"/${P}-gcc4.patch
}
