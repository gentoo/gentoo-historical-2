# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/monster-masher/monster-masher-1.6.1.ebuild,v 1.1 2004/05/28 21:27:13 mr_bones_ Exp $

DESCRIPTION="Squash the monsters with your levitation worker gnome"
HOMEPAGE="http://www.cs.auc.dk/~olau/monster-masher/"
SRC_URI="http://www.cs.auc.dk/~olau/monster-masher/source/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE=""

DEPEND="virtual/x11
	dev-cpp/gtkmm
	dev-cpp/libgnomemm
	dev-cpp/libgnomeuimm
	dev-cpp/gconfmm
	dev-cpp/libglademm"

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog README
}
