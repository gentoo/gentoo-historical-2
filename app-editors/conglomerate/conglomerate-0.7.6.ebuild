# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/conglomerate/conglomerate-0.7.6.ebuild,v 1.6 2004/10/05 12:19:43 pvdabeel Exp $

inherit gnome2

DESCRIPTION="XML editor"
HOMEPAGE="http://www.conglomerate.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"
IUSE="doc"

RDEPEND="dev-libs/libxml2
	dev-libs/libxslt
	>=gnome-base/libbonobo-2
	>=gnome-base/libbonoboui-2
	>=gnome-base/libgnomeui-2
	>=gnome-base/libglade-2
	>=x11-libs/gtksourceview-0.6"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( >=dev-util/gtk-doc-0.6 )"

DOCS="AUTHORS BUGS ChangeLog INSTALL NEWS README* TODO"
