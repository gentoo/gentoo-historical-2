# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/libgnomecanvasmm/libgnomecanvasmm-2.0.0.ebuild,v 1.6 2004/06/24 21:49:59 agriffis Exp $

inherit gnome2


DESCRIPTION="C++ bindings for libgnomecanvasmm"
SRC_URI="mirror://sourceforge/gtkmm/${P}.tar.gz"
HOMEPAGE="http://gtkmm.sourceforge.net/"

IUSE=""
SLOT="2"
LICENSE="LGPL-2.1"
KEYWORDS="x86 ~ppc sparc amd64"

RDEPEND=">=gnome-base/libgnomecanvas-2.0.0
	>=dev-cpp/gtkmm-2.0.1"

DEPEND=">=dev-util/pkgconfig-0.12.0
	${RDEPEND}"

DOCS="AUTHORS COPYING ChangeLog NEWS README TODO INSTALL"
