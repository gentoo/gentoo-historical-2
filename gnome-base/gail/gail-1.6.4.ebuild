# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gail/gail-1.6.4.ebuild,v 1.2 2004/06/06 10:54:34 lv Exp $

inherit gnome2

IUSE=""

DESCRIPTION="Accessibility support for Gtk+ and libgnomecanvas"
HOMEPAGE="http://developer.gnome.org/projects/gap"

SLOT="0"
KEYWORDS="~x86 ~ppc ~alpha ~sparc ~hppa amd64 ~ia64 ~mips"
LICENSE="LGPL-2"

RDEPEND=">=x11-libs/gtk+-2.3.5
	>=dev-libs/atk-1.5
	>=gnome-base/libgnomecanvas-2"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS="AUTHORS ChangeLog COPYING NEWS README"
