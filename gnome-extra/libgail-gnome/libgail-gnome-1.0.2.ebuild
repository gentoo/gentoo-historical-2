# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/libgail-gnome/libgail-gnome-1.0.2.ebuild,v 1.9 2004/03/20 18:28:12 leonardop Exp $

inherit gnome2

DESCRIPTION="GAIL libraries for Gnome2 "
HOMEPAGE="http://www.gnome.org/"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha hppa amd64 ia64"
LICENSE="LGPL-2"
IUSE=""

RDEPEND=">=gnome-base/libgnomeui-2
	>=gnome-base/libbonoboui-2
	>=gnome-base/libbonobo-2
	>=gnome-extra/at-spi-1
	>=dev-libs/atk-1.0.3
	>=x11-libs/gtk+-2"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0"

DOCS="AUTHORS COPYING ChangeLog INSTALL NEWS README"
