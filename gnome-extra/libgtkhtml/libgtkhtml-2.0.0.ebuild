# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/libgtkhtml/libgtkhtml-2.0.0.ebuild,v 1.1 2002/06/07 20:12:41 stroke Exp $

inherit gnome2

S=${WORKDIR}/${P}
DESCRIPTION="a Gtk+ based HTML rendering library"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/pre-gnome2/sources/libgtkhtml/${P}.tar.bz2"
HOMEPAGE="http://www.gnome.org/"
SLOT="1"
LICENSE="LGPL-2.1 GPL-2"

RDEPEND=">=x11-libs/gtk+-2.0.1
	>=dev-libs/libxml2-2.4.22
	>=gnome-base/gnome-vfs-1.9.10
	>=gnome-base/gail-0.9"


DEPEND="${RDEPEND}
	 >=dev-util/pkgconfig-0.12.0"

LIBTOOL_FIX="1"
DOCS="AUTHORS COPYING*  ChangeLog INSTALL NEWS  README* TODO docs/IDEAS"



