# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gail/gail-1.2.0.ebuild,v 1.5 2003/02/22 04:37:20 agriffis Exp $

inherit gnome2

IUSE="doc"
S=${WORKDIR}/${P}

DESCRIPTION="Part of Gnome Accessibility"
HOMEPAGE="http://www.gnome.org/"

SLOT="0"
KEYWORDS="x86 ~ppc alpha"
LICENSE="GPL-2"

DEPEND=">=x11-libs/gtk+-2.1.3
	>=dev-libs/atk-1.1.3
	>=gnome-base/libgnomecanvas-2"

RDEPEND="${DEPEND}
	>=dev-util/pkgconfig-0.12.0
	doc? ( >=dev-util/gtk-doc-0.9 )"

DOCS="AUTHORS ChangeLog COPYING README INSTALL NEWS"
