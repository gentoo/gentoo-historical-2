# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/libgnomeuimm/libgnomeuimm-1.3.16.ebuild,v 1.1 2003/06/20 23:44:44 liquidx Exp $


inherit gnome2

S=${WORKDIR}/${P}
SLOT="0"
DESCRIPTION="C++ bindings for libgnomeuimm"
SRC_URI="mirror://sourceforge/gtkmm/${P}.tar.gz"
HOMEPAGE="http://gtkmm.sourceforge.net/"
LICENSE="LGPL-2.1"
KEYWORDS="~x86 ~ppc"


RDEPEND=">=gnome-base/libgnomeui-2.0.0
	>=dev-cpp/libgnomemm-1.3.8
	>=dev-cpp/libgnomecanvasmm-2.0
	>=dev-cpp/gconfmm-2.0.1
	>=dev-cpp/libbonobouimm-1.3.5
	>=x11-libs/gtkmm-2.0.0
	>=dev-cpp/libglademm-2.0.0"

DEPEND=">=dev-util/pkgconfig-0.12.0
	${RDEPEND}"


DOCS="AUTHORS COPYING ChangeLog NEWS README TODO"
