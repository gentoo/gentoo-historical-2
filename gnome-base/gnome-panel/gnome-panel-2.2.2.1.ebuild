# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-panel/gnome-panel-2.2.2.1.ebuild,v 1.3 2003/07/09 16:25:49 liquidx Exp $

inherit gnome2 eutils

DESCRIPTION="The Panel for Gnome2"
HOMEPAGE="http://www.gnome.org/"

SLOT="0"
LICENSE="GPL-2 FDL-1.1 LGPL-2"
KEYWORDS="~x86 ~ppc ~alpha ~sparc hppa"

IUSE="doc"
MAKEOPTS="${MAKEOPTS} -j1"

RDEPEND=">=x11-libs/gtk+-2.1
	>=x11-libs/libwnck-2.1.5
	>=gnome-base/ORBit2-2.4
	>=gnome-base/gnome-vfs-2.1.3
	>=gnome-base/gnome-desktop-2.1.4
	>=gnome-base/libbonoboui-2.1.1
	>=gnome-base/libglade-2
	>=gnome-base/libgnome-2.1.1
	>=gnome-base/libgnomeui-2.1
	>=app-text/scrollkeeper-0.3.11	
	!gnome-extra/system-tray-applet"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	>=dev-util/intltool-0.21
	doc? ( >=dev-util/gtk-doc-0.9 )"

DOCS="AUTHORS COPYING* ChangeLog HACKING INSTALL NEWS README"
