# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/libbonobouimm/libbonobouimm-1.3.5.ebuild,v 1.4 2003/09/12 19:40:00 liquidx Exp $

inherit gnome2

DESCRIPTION="C++ bindings for libbonoboui"
SRC_URI="mirror://sourceforge/gtkmm/${P}.tar.gz"
HOMEPAGE="http://gtkmm.sourceforge.net/"

IUSE=""
SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~x86 ~ppc ~sparc"

RDEPEND=">=gnome-base/libbonobo-2.0
	>=gnome-base/libbonoboui-2.0
	>=gnome-base/ORBit2-2
	>=dev-cpp/gtkmm-2.0.0
	>=dev-cpp/orbitcpp-1.3.5
	>=dev-cpp/libbonobomm-1.3.5"

DEPEND=">=dev-util/pkgconfig-0.12.0
	${RDEPEND}"

# Needed for 2.0.0, it misses some make/libtool magic
export SED=sed

DOCS="AUTHORS COPYING ChangeLog NEWS README TODO INSTALL"
