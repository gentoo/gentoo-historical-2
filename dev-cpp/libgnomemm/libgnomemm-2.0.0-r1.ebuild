# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/libgnomemm/libgnomemm-2.0.0-r1.ebuild,v 1.1 2003/10/15 10:09:22 liquidx Exp $

inherit gnome2

DESCRIPTION="C++ bindings for libgnome"
SRC_URI="mirror://sourceforge/gtkmm/${P}.tar.gz"
HOMEPAGE="http://gtkmm.sourceforge.net/"
LICENSE="LGPL-2.1"

KEYWORDS="~x86 ~ppc ~sparc"
SLOT="0"

RDEPEND=">=dev-cpp/gtkmm-2
	>=gnome-base/libgnome-2"

DEPEND=">=dev-util/pkgconfig-0.12.0
	${RDEPEND}"

DOCS="AUTHORS COPYING ChangeLog NEWS README TODO"

src_unpack() {
	unpack ${A}
	# patch to fix typo in .pc files
	EPATCH_OPTS="-d ${S}" epatch ${FILESDIR}/${P}-pkgconfig.patch
}
