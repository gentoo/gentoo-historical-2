# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/plib/plib-1.6.0.ebuild,v 1.8 2003/10/06 14:21:03 agriffis Exp $

DESCRIPTION="multimedia library used by many games"
HOMEPAGE="http://plib.sourceforge.net/"
SRC_URI="http://plib.sourceforge.net/dist/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="x86 ppc ~sparc amd64 alpha"

DEPEND="sys-devel/autoconf"
RDEPEND="virtual/x11
	virtual/glut"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i 's:-O6 ::' configure.in
	autoconf || die
}

src_install() {
	einstall || die
}
