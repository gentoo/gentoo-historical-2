# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gail/gail-0.15.ebuild,v 1.1 2002/06/05 22:33:52 stroke Exp $

inherit gnome2

S=${WORKDIR}/${P}
DESCRIPTION="Part of Gnome Accessibility"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/pre-gnome2/sources/gail/${P}.tar.bz2"
HOMEPAGE="http://www.gnome.org/"
SLOT="0"

DEPEND=">=dev-util/pkgconfig-0.12.0
	>=x11-libs/gtk+-2.0.0
	>=dev-libs/glib-2.0.0
	>=x11-libs/pango-1.0.0
	>=dev-libs/atk-1.0.0
	>=gnome-base/libgnomecanvas-1.112.1"

DOCS="AUTHORS ChangeLog COPYING README* INSTALL NEWS"

