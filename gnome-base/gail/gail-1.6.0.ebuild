# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gail/gail-1.6.0.ebuild,v 1.8 2004/11/08 20:00:42 vapier Exp $

inherit gnome2

DESCRIPTION="Accessibility support for Gtk+ and libgnomecanvas"
HOMEPAGE="http://developer.gnome.org/projects/gap"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="x86 ppc ~alpha ~sparc hppa ~amd64 ia64 ~mips arm"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.3.5
	>=dev-libs/atk-1.5
	>=gnome-base/libgnomecanvas-2"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS="AUTHORS ChangeLog COPYING NEWS README NEWS"
