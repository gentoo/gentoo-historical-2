# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gnome-themes/gnome-themes-2.2.2-r1.ebuild,v 1.3 2003/07/19 23:55:04 tester Exp $

# FIXME : the engines in here should probably be disabled and done in seperate ebuilds

inherit gnome2

DESCRIPTION="A set of gnome2 themes, with sets for users with limited or low vision"
HOMEPAGE="http://www.gnome.org/softwaremap/projects/gnome-themes"

IUSE=""
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa ~amd64"
LICENSE="GPL-2"

RDEPEND=">=x11-libs/gtk+-2
	>=gnome-base/libgnomeui-2
	>=gnome-base/libglade-2
	>=x11-themes/gtk-engines-thinice-2.0.2
	>=x11-themes/gtk-engines-2.2.0"

DEPEND=">=dev-util/pkgconfig-0.12.0
	>=dev-util/intltool-0.23
	>=sys-apps/sed-4"

DOCS="AUTHORS COPY* README INSTALL NEWS ChangeLog"
