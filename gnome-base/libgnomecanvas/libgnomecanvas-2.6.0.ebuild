# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgnomecanvas/libgnomecanvas-2.6.0.ebuild,v 1.8 2004/07/04 18:49:54 kloeri Exp $

inherit gnome2

IUSE="doc"
DESCRIPTION="The Gnome 2 Canvas library"
HOMEPAGE="http://www.gnome.org/"

SLOT="0"
KEYWORDS="x86 ppc alpha ~sparc hppa amd64 ~ia64 mips"
LICENSE="GPL-2 LGPL-2"

RDEPEND=">=gnome-base/libglade-2
	>=x11-libs/gtk+-2.0.3
	>=x11-libs/pango-1.2
	>=media-libs/libart_lgpl-2.3.8"

DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.12.0
	doc? ( >=dev-util/gtk-doc-0.9-r2 )"

DOCS="AUTHORS COPYING* ChangeLog INSTALL NEWS README"
