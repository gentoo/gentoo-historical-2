# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libwnck/libwnck-0.15.ebuild,v 1.5 2002/10/04 06:39:54 vapier Exp $

inherit gnome2

S=${WORKDIR}/${P}
DESCRIPTION="A window navigation construction kit"
SRC_URI="mirror://gnome/2.0.0/sources/${PN}/${P}.tar.bz2"
HOMEPAGE="http://www.gnome.org/"
SLOT="0"
KEYWORDS="x86 ppc sparc sparc64 alpha"

RDEPEND="virtual/glibc
	x11-libs/pango
	dev-libs/glib
	>=x11-libs/gtk+-2.0.2"		
DEPEND=">=dev-util/pkgconfig-0.12.0 ${RDEPEND}"


LICENSE="GPL-2"
DOCS="ABOUT-NLS AUTHORS COPYING  ChangeLog INSTALL NEWS README"





