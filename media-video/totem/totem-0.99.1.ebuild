# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/totem/totem-0.99.1.ebuild,v 1.3 2003/09/04 20:07:25 spider Exp $

inherit gnome2

IUSE="gstreamer"
DESCRIPTION="Movie player for the GNOME 2"
HOMEPAGE="http://www.hadess.net/totem.php3"

SLOT="0"
KEYWORDS="x86 ~ppc"
LICENSE="GPL-2"

RDEPEND=">=dev-libs/glib-2.1
	>=x11-libs/gtk+-2
	>=gnome-base/libgnomeui-2.1.1
	>=gnome-base/gnome-vfs-2.2
	>=gnome-base/libglade-2
	>=gnome-base/gnome-desktop-2.2
	!gstreamer? ( >=media-libs/xine-lib-1_beta12 )
	gstreamer? ( >=media-libs/gstreamer-0.6.1
		>=media-libs/gst-plugins-0.6.1 )"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.20
	>=dev-util/pkgconfig-0.12.0"

DOCS="AUTHORS ChangeLog COPYING*  README* INSTALL NEWS"

# xine is default
if [ `use gstreamer` ]; then
	G2CONF="${G2CONF} --enable-gstreamer"
fi
