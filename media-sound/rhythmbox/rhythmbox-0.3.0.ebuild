# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/rhythmbox/rhythmbox-0.3.0.ebuild,v 1.4 2003/02/13 13:18:03 vapier Exp $

inherit gnome2

S=${WORKDIR}/${P}
DESCRIPTION="RhythmBox - an iTunes clone for GNOME"
SRC_URI="http://www.rhythmbox.org/download/${P}.tar.gz"
HOMEPAGE="http://www.rhythmbox.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

RDEPEND=">=x11-libs/gtk+-2.0.0
	>=gnome-base/libgnomeui-1.117.2
	>=gnome-base/libglade-1.99.12
	>=gnome-base/gnome-panel-1.5.23	
	>=gnome-base/gnome-vfs-1.9.16
	>=gnome-base/libbonobo-1.117.1
	>=gnome-base/bonobo-activation-0.9.9
	>=gnome-base/libgnomecanvas-1.117.0
	>=media-libs/monkey-media-0.5.0
	>=gnome-base/gconf-1.2.1
	>=gnome-base/ORBit2-2.4.1
	>=sys-devel/gettext-0.11.1
	>=media-libs/gst-plugins-0.4.0"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	dev-util/intltool"

LIBTOOL_FIX="1"
src_unpack() {
	unpack ${A}
	cd ${S}
	cp configure configure.orig
	sed "s|-Werror||" configure.orig > configure
	chmod +x configure
	
}

DOC="AUTHORS COPYING ChangeLog FAQ HACKING INSTALL NEWS README THANKS TODO"
SCHEMA="rhythmbox.schemas"
