# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/libglademm/libglademm-1.3.0.ebuild,v 1.1 2002/06/02 17:24:26 spider Exp $

inherit gnome2

S=${WORKDIR}/${P}
SLOT="0"
DESCRIPTION="C++ bindings for libglade"
SRC_URI="mirror://sourceforge/gtkmm/${P}.tar.gz"
HOMEPAGE="http://gtkmm.sourceforge.net/"
LICENSE="LGPL-2.1"


RDEPEND=">=gnome-base/libglade-1.99.12-r2"


DEPEND=">=dev-util/pkgconfig-0.12.0
	${RDEPEND}"

DOC="AUTHORS COPYING ChangeLog NEWS README TODO"
