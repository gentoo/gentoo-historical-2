# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gail/gail-1.8.5.ebuild,v 1.1 2005/08/31 09:35:34 leonardop Exp $

inherit gnome2

DESCRIPTION="Accessibility support for Gtk+ and libgnomecanvas"
HOMEPAGE="http://developer.gnome.org/projects/gap/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc static"

RDEPEND=">=dev-libs/atk-1.7
	>=x11-libs/gtk+-2.3.5
	>=gnome-base/libgnomecanvas-2"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog NEWS README"
USE_DESTDIR="1"


pkg_setup() {
	G2CONF="$(use_enable static)"
}
