# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-panel/gnome-panel-2.0.6.ebuild,v 1.3 2002/09/05 21:34:48 spider Exp $

MAKEOPTS="-j1"
inherit gnome2

S=${WORKDIR}/${P}
DESCRIPTION="The Panel for Gnome2"
SRC_URI="mirror://gnome/2.0.0/sources/${PN}/${P}.tar.bz2"
HOMEPAGE="http://www.gnome.org/"

SLOT="0"
LICENSE="GPL-2 FDL-1.1 LGPL-2.1"
KEYWORDS="x86 ppc sparc sparc64"

RDEPEND=">=x11-libs/gtk+-2.0.6-r1
	>=dev-libs/libxml2-2.4.22
	>=dev-libs/atk-1.0.3-r1
	>=dev-libs/glib-2.0.6-r1
	>=media-libs/libart_lgpl-2.3.10
	>=x11-libs/libwnck-0.14
	>=net-libs/linc-0.5.1
	>=media-libs/audiofile-0.2.3
	>=sys-libs/zlib-1.1.4
	>=app-text/scrollkeeper-0.3.10-r1
	>=gnome-base/ORBit2-2.4.0-r3
	>=gnome-base/bonobo-activation-1.0.3
	>=gnome-base/gconf-1.2.1
	>=gnome-base/gnome-vfs-2.0.1
	>=gnome-base/gnome-desktop-2.0.6
	>=gnome-base/libbonobo-2.0.0-r1
	>=gnome-base/libbonoboui-2.0.1
	>=gnome-base/libglade-2.0.0
	>=gnome-base/libgnome-2.0.2
	>=gnome-base/libgnomecanvas-2.0.1
	>=gnome-base/libgnomeui-2.0.3"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	>=dev-util/intltool-0.17
	doc? ( >=dev-util/gtk-doc-0.9-r2 )"

DOCS="AUTHORS COPYING* ChangeLog HACKING INSTALL NEWS  README*"
