# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libwnck/libwnck-2.2.1.ebuild,v 1.8 2003/07/04 21:01:41 gmsoft Exp $

inherit gnome2

S=${WORKDIR}/${P}
DESCRIPTION="A window navigation construction kit"
HOMEPAGE="http://www.gnome.org/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc alpha ~sparc hppa"

RDEPEND="virtual/glibc
	>=dev-libs/glib-2
	>=x11-libs/gtk+-2.1"		

DEPEND=">=dev-util/pkgconfig-0.12.0 ${RDEPEND}"

DOCS="AUTHORS COPYING ChangeLog INSTALL NEWS README"
