# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Geert Bevin <gbevin@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-libs/plib/plib-1.4.2-r1.ebuild,v 1.1 2002/02/11 04:43:00 drobbins Exp $

S=${WORKDIR}/${P}
SRC_URI="http://plib.sourceforge.net/dist/${P}.tar.gz"
HOMEPAGE="http://plib.sourceforge.net"
DESCRIPTION="plib: a multimedia library used by many games"
RDEPEND="virtual/x11 virtual/glut"
DEPEND="$RDEPEND sys-devel/autoconf"

src_unpack() {
	unpack $A
	cd $S
	cp configure.in configure.in.orig
	sed -e 's:-O6 ::' configure.in.orig > configure.in
	rm configure
	autoconf
}

src_install() {
	einstall || die
}
