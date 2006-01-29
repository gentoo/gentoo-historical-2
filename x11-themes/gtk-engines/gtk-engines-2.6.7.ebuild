# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines/gtk-engines-2.6.7.ebuild,v 1.6 2006/01/29 22:23:18 weeve Exp $

inherit gnome2

DESCRIPTION="GTK+2 standard engines and themes"
HOMEPAGE="http://www.gtk.org/"

KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ppc ppc64 sparc x86"
LICENSE="GPL-2 LGPL-2.1"
SLOT="2"
IUSE="accessibility"

RDEPEND=">=x11-libs/gtk+-2.6
	!<=x11-themes/gnome-themes-2.8.2"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9"

DOCS="AUTHORS ChangeLog NEWS README"


pkg_setup() {
	use accessibility || G2CONF="--disable-hc"
}
