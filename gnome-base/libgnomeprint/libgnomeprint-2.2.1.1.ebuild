# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgnomeprint/libgnomeprint-2.2.1.1.ebuild,v 1.2 2003/02/07 20:31:46 agriffis Exp $

inherit gnome2

S=${WORKDIR}/${P}
DESCRIPTION="Printer handling for Gnome"
HOMEPAGE="http://www.gnome.org/"
SLOT="2.2"
KEYWORDS="~x86 ~ppc ~alpha"
LICENSE="GPL-2 LGPL-2.1"

RDEPEND=">=dev-libs/glib-2
	>=x11-libs/pango-1
	>=media-libs/fontconfig-1
	>=media-libs/libart_lgpl-2.3.7
	>=dev-libs/libxml2-2.4.23
	>=media-libs/freetype-2.0.5"
		
DEPEND="${RDEPEND} 
	>=dev-util/pkgconfig-0.12.0
	doc? ( >=dev-util/gtk-doc-0.10 )"

DOCS="AUTHORS COPYING* ChangeLog* INSTALL NEWS README"
