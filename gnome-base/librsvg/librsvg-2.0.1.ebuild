# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/librsvg/librsvg-2.0.1.ebuild,v 1.9 2003/02/13 12:14:32 vapier Exp $
inherit gnome2

S=${WORKDIR}/${P}
DESCRIPTION="rendering svg library"
SRC_URI="mirror://gnome/2.0.0/sources/${PN}/${P}.tar.bz2"
HOMEPAGE="http://www.gnome.org/"
SLOT="2"
KEYWORDS="x86 ppc sparc alpha"
LICENSE="GPL-2 LGPL-2.1"

RDEPEND=">=dev-libs/glib-2.0.4
	>=x11-libs/gtk+-2.0.5
	>=media-libs/libart_lgpl-2.3.10
	>=dev-libs/libxml2-2.4.17
	>=x11-libs/pango-1.0.3"

DEPEND="${RDEPEND} 
	>=dev-util/pkgconfig-0.12.0"
	
G2CONF="${G2CONF} --enable-platform-gnome-2"

DOCS="AUTHORS ChangeLog COPYIN* README INSTALL NEWS TODO"


