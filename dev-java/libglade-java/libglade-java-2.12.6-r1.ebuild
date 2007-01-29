# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/libglade-java/libglade-java-2.12.6-r1.ebuild,v 1.2 2007/01/29 09:24:58 opfer Exp $

inherit java-gnome

DESCRIPTION="Java bindings for Glade"
HOMEPAGE="http://java-gnome.sourceforge.net/"

LICENSE="LGPL-2.1"
SLOT="2.12"
KEYWORDS="~amd64 ~ppc x86"
IUSE="gnome"

DEPS=">=gnome-base/libglade-2.5.1
		>=dev-java/glib-java-0.2.3
		>=dev-java/libgnome-java-2.8.0
		gnome? ( >=gnome-base/libgnomeui-2.12.0
		>=gnome-base/libgnomecanvas-2.12.0 )"
DEPEND="${DEPS}"
RDEPEND="${DEPS}"

src_compile() {
	java-gnome_src_compile $(use_with gnome)
}
