# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gal2/gal2-0.0.4-r1.ebuild,v 1.1 2002/06/15 13:00:25 spider Exp $

inherit gnome2
S=${WORKDIR}/gal2-0-${PV}
DESCRIPTION="A text editor for the Gnome2 desktop"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/pre-gnome2/sources/gal2/gal2-0-${PV}.tar.bz2"
HOMEPAGE="http://www.gnome.org/"
SLOT="0"
LICENSE="GPL-2 LGPL-2.1"

DEPEND="virtual/glibc
	gnome-base/libgnomeprint
	gnome-base/libgnomeprintui
	gnome-base/libglade
	gnome-base/libgnomeui
	gnome-base/libgnomecanvas
	dev-libs/libxml2"
RDEPEND=${DEPEND}

DOCS="AUTHORS BUGS ChangeLog COPYING COPYING.LIB FAQ INSTALL NEWS  README*  THANKS TODO"





