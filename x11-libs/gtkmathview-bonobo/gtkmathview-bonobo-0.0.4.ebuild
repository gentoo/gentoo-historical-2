# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/gtkmathview-bonobo/gtkmathview-bonobo-0.0.4.ebuild,v 1.3 2004/09/03 15:35:20 pvdabeel Exp $

inherit gnome2

DESCRIPTION="Bonobo wrapper for GtkMathView"
HOMEPAGE="http://helm.cs.unibo.it/gtkmathview-bonobo/"
SRC_URI="http://helm.cs.unibo.it/gtkmathview-bonobo/sources/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ppc"
IUSE=""

RDEPEND=">=x11-libs/gtkmathview-0.6.2
	>=gnome-base/libbonobo-2.0
	>=gnome-base/libbonoboui-2.0
	>=gnome-base/libgnomeui-2.0"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS="AUTHORS ChangeLog INSTALL NEWS README"
