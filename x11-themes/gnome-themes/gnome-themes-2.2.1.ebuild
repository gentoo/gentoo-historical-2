# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gnome-themes/gnome-themes-2.2.1.ebuild,v 1.2 2003/03/14 15:16:09 foser Exp $

inherit gnome2

DESCRIPTION="A set of gnome2 themes, with sets for users with limited or low vision"
HOMEPAGE="http://www.gnome.org/softwaremap/projects/gnome-themes"

SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha"
LICENSE="GPL-2"

RDEPEND=">=x11-libs/gtk+-2
	>=x11-themes/gtk-engines-thinice-2.0.2
	>=x11-themes/gtk-engines-metal-2.2
	>=x11-themes/gtk-engines-redmond95-2.2
	>=x11-themes/gtk-engines-pixbuf-2.2"

DEPEND=">=dev-util/pkgconfig-0.12.0
	>=dev-util/intltool-0.23"

DOC="AUTHORS COPY* README INSTALL NEWS ChangeLog"

src_compile() {
        cd ${S}
        mv configure.in configure.in.old
        sed -e "s:gtk-engines-2::" configure.in.old > configure.in
 
	autoconf

	gnome2_src_compile
}
