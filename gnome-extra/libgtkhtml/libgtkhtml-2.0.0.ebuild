# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/libgtkhtml/libgtkhtml-2.0.0.ebuild,v 1.7 2003/02/13 12:23:04 vapier Exp $

inherit gnome2

S=${WORKDIR}/${P}
DESCRIPTION="a Gtk+ based HTML rendering library"
SRC_URI="mirror://gnome/2.0.0/sources/${PN}/${P}.tar.bz2"
HOMEPAGE="http://www.gnome.org/"
SLOT="1"
LICENSE="LGPL-2.1 GPL-2"
KEYWORDS="x86 ppc sparc "

RDEPEND=">=x11-libs/gtk+-2.0.1
	>=dev-libs/libxml2-2.4.22
	>=gnome-base/gnome-vfs-1.9.10
	>=gnome-base/gail-0.9"


DEPEND="${RDEPEND}
	 >=dev-util/pkgconfig-0.12.0"

DOCS="AUTHORS COPYING*  ChangeLog INSTALL NEWS  README* TODO docs/IDEAS"



