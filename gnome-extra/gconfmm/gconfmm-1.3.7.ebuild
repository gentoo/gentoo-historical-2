# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gconfmm/gconfmm-1.3.7.ebuild,v 1.5 2003/02/13 12:17:31 vapier Exp $

inherit gnome2

S=${WORKDIR}/${P}
SLOT="0"
DESCRIPTION="C++ bindings for libgconf"
SRC_URI="mirror://sourceforge/gtkmm/${P}.tar.gz"
HOMEPAGE="http://gtkmm.sourceforge.net/"
LICENSE="LGPL-2.1"
KEYWORDS="~x86 ~ppc ~sparc"

RDEPEND=">=gnome-base/gconf-1.2.0
	>=x11-libs/gtkmm-1.3.17"


DEPEND=">=dev-util/pkgconfig-0.12.0
	${RDEPEND}"

DOCS="AUTHORS COPYING ChangeLog NEWS README TODO"

