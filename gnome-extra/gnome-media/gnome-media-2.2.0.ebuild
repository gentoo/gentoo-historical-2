# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-media/gnome-media-2.2.0.ebuild,v 1.3 2003/02/09 15:06:33 foser Exp $

#FIXME SANDBOX
#addwrite /usr/share/
inherit gnome2

S=${WORKDIR}/${P}
DESCRIPTION="Multimedia related programs for the Gnome2 desktop"
HOMEPAGE="http://www.prettypeople.org/~iain/gnome-media/"
LICENSE="GPL-2 FDL-1.1"
SLOT="2"
KEYWORDS="~x86 ~ppc"

RDEPEND=">=media-sound/esound-0.2.23
	>=dev-libs/glib-2
	>=x11-libs/gtk+-2
	>=gnome-base/libgnomeui-2
	>=gnome-base/gconf-1.2.1
	>=gnome-base/libglade-2
	>=gnome-base/gnome-desktop-2
	>=gnome-base/gnome-vfs-2
	dev-libs/libxml2
	>=gnome-base/ORBit2-2.4.1
	>=gnome-base/libbonobo-2
	>=gnome-base/bonobo-activation-2
	>=gnome-base/gail-0.0.3
	>=media-libs/gstreamer-0.5.2
	>=media-libs/gst-plugins-0.5.2"

DEPEND=">=dev-util/pkgconfig-0.12.0
	>=app-text/scrollkeeper-0.3.11
	>=dev-util/intltool-0.21
	${RDEPEND}"

DOCS="AUTHORS COPYING* ChangeLog INSTALL NEWS README TODO"

src_unpack() {
	unpack ${A}

	cd ${S}/gstreamer-properties
	WANT_AUTOCONF_2_5=1 autoconf -f
}

src_install() {
	dodir /usr/share/gnome-media-2.0/interfaces

	gnome2_src_install
}
