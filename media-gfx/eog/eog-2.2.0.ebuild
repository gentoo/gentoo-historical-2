# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/eog/eog-2.2.0.ebuild,v 1.8 2003/06/20 21:55:49 liquidx Exp $

inherit gnome2

IUSE="jpeg png"

S=${WORKDIR}/${P}
DESCRIPTION="the Eye Of Gnome - Image Viewer and Cataloger for Gnome2"
HOMEPAGE="http://www.gnome.org/"

SLOT="1"
LICENSE="GPL-2"
KEYWORDS="x86 ppc alpha ~sparc"

RDEPEND=">=gnome-base/gconf-1.2.1
	>=gnome-base/gnome-vfs-2.0.4
	>=gnome-base/libgnomeui-2.0.6
	>=gnome-base/libbonoboui-2.0.3
	>=gnome-base/bonobo-activation-1.0.3
	>=gnome-base/libglade-2.0.1
	>=gnome-base/librsvg-2.0.1
	>=gnome-base/eel-2.2.0
	jpeg? ( media-libs/jpeg )
	png? ( media-libs/libpng )"

DEPEND="${RDEPEND}
	dev-libs/popt
	>=dev-util/pkgconfig-0.12.0
	>=dev-util/intltool-0.22"

DOCS="AUTHORS ChangeLog COPYING README INSTALL NEWS HACKING DEPENDS THANKS  TODO"
