# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-editors/gedit/gedit-1.199.0.ebuild,v 1.1 2002/06/10 20:45:02 spider Exp $


inherit gnome2
# Author: Spider  <spider@gentoo.org>
# Maintainer: Spider <spider@gentoo.org>

S=${WORKDIR}/${P}
DESCRIPTION="A text editor for the Gnome2 desktop"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/pre-gnome2/sources/${PN}2/${PN}2-${PV}.tar.bz2"
HOMEPAGE="http://www.gnome.org/"
SLOT="0"
LICENSE="GPL-2"

RDEPEND=">=x11-libs/pango-1.0.2
	>=x11-libs/gtk+-2.0.3
	>=dev-libs/glib-2.0.3
	>=gnome-base/gconf-1.1.11
	>=gnome-base/libglade-2.0.0
	>=gnome-base/gnome-vfs-1.9.16
	>=gnome-base/libgnomeui-2.0.0
	>=gnome-base/libbonoboui-2.0.0
	>=gnome-base/ORBit2-2.4.0
	>=gnome-base/libgnomeprintui-1.115.0"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	>=dev-util/intltool-0.17"

	
DOCS="AUTHORS BUGS ChangeLog COPYING FAQ INSTALL NEWS  README*  THANKS TODO"



SCHEMAS="gedit.schemas"

