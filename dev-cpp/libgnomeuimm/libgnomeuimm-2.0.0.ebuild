# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/libgnomeuimm/libgnomeuimm-2.0.0.ebuild,v 1.1 2003/09/06 21:26:30 foser Exp $

inherit gnome2

DESCRIPTION="C++ bindings for libgnomeui"
SRC_URI="mirror://sourceforge/gtkmm/${P}.tar.gz"
HOMEPAGE="http://gtkmm.sourceforge.net/"

LICENSE="LGPL-2.1"
IUSE=""
KEYWORDS="~x86 ~ppc"
SLOT="0"

RDEPEND=">=gnome-base/libgnomeui-2.0.0
	>=dev-cpp/libgnomemm-1.3.10
	>=dev-cpp/libgnomecanvasmm-2.0
	>=dev-cpp/gconfmm-2.0.1
	>=dev-cpp/gtkmm-2.0.0
	>=dev-cpp/libglademm-2.0.0"

DEPEND=">=dev-util/pkgconfig-0.12.0
	${RDEPEND}"

DOCS="AUTHORS COPYING ChangeLog NEWS INSTALL TODO"
