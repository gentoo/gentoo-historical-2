# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmtop/wmtop-0.84.ebuild,v 1.2 2002/10/20 18:55:34 vapier Exp $

S="${WORKDIR}/${P}"

DESCRIPTION="top in a dockapp"
HOMEPAGE="http://wmtop.sourceforge.net"
SRC_URI="mirror://sourceforge/wmtop/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/glibc
	virtual/x11"

src_compile() {

	cd ${S}
	cp Makefile Makefile.orig
	sed -e "s:-O3 -g -Wall:${CFLAGS}:" \
		-e "s:/local::" Makefile.orig > Makefile

	make linux

}

src_install() {

	dodir /usr/bin /usr/man/man1
	make PREFIX=${D}/usr install || die "make install failed"

}
