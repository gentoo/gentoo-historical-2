# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/gnome-base/bonobo-activation/bonobo-activation-1.0.0-r1.ebuild,v 1.1 2002/06/04 08:59:46 blocke Exp $

inherit gnome2

S=${WORKDIR}/${P}
DESCRIPTION="Gnome2 replacement for OAF"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/pre-gnome2/sources/${PN}/${P}.tar.bz2"
HOMEPAGE="http://www.gnome.org/"
LICENSE="GPL-2 LGPL-2.1"
SLOT="0"

RDEPEND=">=dev-libs/glib-2.0.1
	>=dev-libs/libxml2-2.4.20
	>=dev-libs/popt-1.6.3
	>=gnome-base/ORBit2-2.3.108"

DEPEND="${RDEPEND} 
	>=dev-util/pkgconfig-0.12.0
	doc? ( >=dev-util/gtk-doc-0.9-r2 
		>=app-text/openjade-1.3 )"

LIBTOOL_FIX="1"

DOCS="AUTHORS  ABOUT-NLS COPYING* ChangeLog  README* INSTALL NEWS TODO docs/* api-docs/*"

src_compile() {
	gnome2_src_compile --enable-bonobo-activation-debug
}

