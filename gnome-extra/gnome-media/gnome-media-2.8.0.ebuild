# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-media/gnome-media-2.8.0.ebuild,v 1.14 2006/08/02 17:31:42 kumba Exp $

inherit gnome2

DESCRIPTION="Multimedia related programs for the Gnome2 desktop"
HOMEPAGE="http://www.prettypeople.org/~iain/gnome-media/"

LICENSE="GPL-2 FDL-1.1"
SLOT="2"
KEYWORDS="alpha amd64 hppa ia64 ppc sparc x86"
IUSE="vorbis mad"

RDEPEND=">=dev-libs/glib-2
	>=x11-libs/gtk+-2.3.1
	>=gnome-base/libgnomeui-2
	>=gnome-base/gconf-1.2.1
	>=gnome-base/gnome-desktop-2
	>=gnome-base/gnome-vfs-2
	dev-libs/libxml2
	>=gnome-base/orbit-2.4.1
	>=gnome-base/libbonobo-2
	>=gnome-base/gail-0.0.3
	>=media-sound/esound-0.2.23
	=media-libs/gstreamer-0.8*
	=media-libs/gst-plugins-0.8*
	vorbis? ( =media-plugins/gst-plugins-vorbis-0.8*
		=media-plugins/gst-plugins-ogg-0.8* )
	mad? ( =media-plugins/gst-plugins-mad-0.8* )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	>=app-text/scrollkeeper-0.3.11
	>=dev-util/intltool-0.29"

DOCS="AUTHORS ChangeLog INSTALL NEWS README TODO"

USE_DESTDIR="1"

src_install() {

	gnome2_src_install scrollkeeper_localstate_dir=${D}/var/lib/scrollkeeper/

}
