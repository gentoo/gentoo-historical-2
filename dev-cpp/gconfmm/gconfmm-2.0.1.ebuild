# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/gconfmm/gconfmm-2.0.1.ebuild,v 1.5 2004/04/12 23:14:45 gmsoft Exp $

inherit gnome2

DESCRIPTION="C++ bindings for GConf"
SRC_URI="mirror://sourceforge/gtkmm/${P}.tar.gz"
HOMEPAGE="http://gtkmm.sourceforge.net/"

IUSE=""
LICENSE="LGPL-2.1"
KEYWORDS="x86 ppc sparc hppa"
SLOT="0"

RDEPEND=">=gnome-base/gconf-1.2.0
	>=dev-cpp/gtkmm-2.0.1"

DEPEND=">=dev-util/pkgconfig-0.12.0
	${RDEPEND}"

DOCS="AUTHORS COPYING* ChangeLog NEWS README INSTALL"
