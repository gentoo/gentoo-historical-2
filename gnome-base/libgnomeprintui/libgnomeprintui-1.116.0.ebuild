# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgnomeprintui/libgnomeprintui-1.116.0.ebuild,v 1.4 2002/09/21 11:49:09 bjb Exp $


inherit gnome2

S=${WORKDIR}/${P}
DESCRIPTION="user interface libraries for gnome print"
SRC_URI="mirror://gnome/2.0.0/sources/${PN}/${P}.tar.bz2"
HOMEPAGE="http://www.gnome.org/"
SLOT="0"
KEYWORDS="x86 ppc sparc sparc64 alpha"
LICENSE="GPL-2 LGPL-2.1"

RDEPEND=">=gnome-base/libgnomeui-2.0.1
	>=gnome-base/libgnomeprint-1.116.0
	>=gnome-base/libgnomecanvas-2.0.1"

DEPEND="${RDEPEND} >=dev-util/pkgconfig-0.12.0"

DOCS="AUTHORS COPYING* ChangeLog INSTALL NEWS README"

