# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmtimer/wmtimer-2.4.ebuild,v 1.5 2002/10/20 18:55:34 vapier Exp $

S=${WORKDIR}/${P}
S2=${S}/wmtimer

DESCRIPTION="Dockable clock which can run in alarm, countdown timer or chronograph mode"
SRC_URI="http://home.dwave.net/~jking/wmtimer/${P}.tar.gz"
HOMEPAGE="http://home.dwave.net/~jking/wmtimer/"

SLOT="0"
LICENSE="GPL"
KEYWORDS="x86"

DEPEND="virtual/glibc
	virtual/x11
	=x11-libs/gtk+-1.2*"

src_compile() {

	cd ${S2}
	cp Makefile Makefile.orig
	sed -e "s:-O2 -Wall:${CFLAGS}:" Makefile.orig > Makefile

	emake || die

}

src_install () {

	cd ${S2}
	dobin wmtimer

	cd ${S}
	dodoc README COPYING INSTALL CREDITS INSTALL Changelog 

}
