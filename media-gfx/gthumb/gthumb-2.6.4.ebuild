# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gthumb/gthumb-2.6.4.ebuild,v 1.2 2005/04/24 10:03:32 vapier Exp $

inherit gnome2

DESCRIPTION="Image viewer and browser for Gnome"
HOMEPAGE="http://gthumb.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86"
IUSE="jpeg tiff png gphoto2"

# FIXME : configure switches, no autodetection

RDEPEND=">=dev-libs/glib-2.4
	>=x11-libs/gtk+-2.4
	>=dev-libs/libxml2-2.4
	>=gnome-base/libgnome-2.6
	>=gnome-base/libgnomeui-2.6
	>=gnome-base/libgnomecanvas-2.6
	>=gnome-base/gnome-vfs-2.6
	>=gnome-base/libglade-2.4
	>=gnome-base/libgnomeprint-2.6
	>=gnome-base/libgnomeprintui-2.6
	>=gnome-base/libbonobo-2.6
	>=gnome-base/libbonoboui-2.6
	>=gnome-base/gconf-2.6
	png? ( media-libs/libpng )
	tiff? ( media-libs/tiff )
	jpeg? ( media-libs/jpeg
		>=media-libs/libexif-0.5.12 )
	gphoto2? ( >=media-libs/libgphoto2-2.1.3 )"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9.0
	app-text/scrollkeeper
	>=dev-util/intltool-0.29"

DOCS="AUTHORS ChangeLog INSTALL NEWS README"

USE_DESTDIR="1"

src_unpack() {

	unpack ${A}

	rm ${S}/components/catalog-view/*.server
	rm ${S}/components/image-viewer/*.server

}
