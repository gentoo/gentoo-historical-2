# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gail/gail-0.17.ebuild,v 1.5 2002/10/04 05:33:21 vapier Exp $

inherit gnome2

S=${WORKDIR}/${P}
DESCRIPTION="Part of Gnome Accessibility"
SRC_URI="mirror://gnome/2.0.0/sources/${PN}/${P}.tar.bz2"
HOMEPAGE="http://www.gnome.org/"
SLOT="0"
KEYWORDS="x86 ppc sparc sparc64 alpha"
LICENSE="GPL-2"

DEPEND=">=dev-util/pkgconfig-0.12.0
	>=x11-libs/gtk+-2.0.5
	>=dev-libs/glib-2.0.4
	>=x11-libs/pango-1.0.2
	>=dev-libs/atk-1.0.2
	>=gnome-base/libgnomecanvas-2.0.0"

DOCS="AUTHORS ChangeLog COPYING README* INSTALL NEWS"

