# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/bonobo-activation/bonobo-activation-2.1.0.ebuild,v 1.1 2002/10/27 14:42:11 foser Exp $

IUSE="doc"

inherit gnome2 debug

S=${WORKDIR}/${P}
DESCRIPTION="Gnome2 replacement for OAF"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="x86 ppc sparc sparc64 alpha"

RDEPEND=">=dev-libs/glib-2.0.1
	>=dev-libs/libxml2-2.4.20
	>=dev-libs/popt-1.5
	>=gnome-base/ORBit2-2.4.0
	>=net-libs/linc-0.5.1"

DEPEND="${RDEPEND} 
	>=dev-util/pkgconfig-0.12.0
	doc? ( >=dev-util/gtk-doc-0.9-r2 
		>=app-text/openjade-1.3 )"

LIBTOOL_FIX="1"

DOCS="AUTHORS  ABOUT-NLS COPYING* ChangeLog  README* INSTALL NEWS TODO docs/* api-docs/*"


