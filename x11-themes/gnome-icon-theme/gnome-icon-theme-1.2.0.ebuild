# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gnome-icon-theme/gnome-icon-theme-1.2.0.ebuild,v 1.2 2004/05/20 23:37:21 foser Exp $

inherit gnome2

DESCRIPTION="GNOME 2 default icon themes"
HOMEPAGE="http://www.gnome.org/"
LICENSE="GPL-2"

IUSE=""
SLOT="0"
KEYWORDS="x86 ~ppc ~alpha ~sparc ~hppa ~amd64 ~ia64 ~mips"

DEPEND="sys-devel/gettext
	x11-themes/hicolor-icon-theme
	>=dev-util/intltool-0.29"

DOCS="AUTHORS COPYING README INSTALL NEWS ChangeLog"
