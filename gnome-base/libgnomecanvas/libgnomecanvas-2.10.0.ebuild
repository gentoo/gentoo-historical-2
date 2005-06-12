# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgnomecanvas/libgnomecanvas-2.10.0.ebuild,v 1.4 2005/06/12 12:19:10 dertobi123 Exp $

inherit gnome2

DESCRIPTION="The Gnome 2 Canvas library"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="x86 ~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ppc ~ppc64 sparc"
IUSE="doc"

RDEPEND=">=gnome-base/libglade-2
	>=x11-libs/gtk+-2.0.3
	>=x11-libs/pango-1.2
	>=media-libs/libart_lgpl-2.3.8"

DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.12.0
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog NEWS README"
USE_DESTDIR="1"
