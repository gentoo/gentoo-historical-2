# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/e-fancylauncher/e-fancylauncher-0.7-r1.ebuild,v 1.1 2003/03/01 20:55:15 lostlogic Exp $

S="${WORKDIR}/Epplets-${PV}"

DESCRIPTION="E-FancyLauncher epplet"
SRC_URI="http://www.docs.uu.se/~adavid/Epplets/E-FancyLauncher-${PV}.tgz"

HOMEPAGE="http://www.docs.uu.se/~adavid/Epplets"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc"
S=${WORKDIR}/E-FancyLauncher

DEPEND="x11-misc/epplet-base"

src_compile() {
	make clean
	emake
}

src_install () {
	sed -e 's/mkdir/mkdir -p/' ${S}/makefile > tmp~
	mv tmp~ makefile
	dodir /usr/bin
	dodir /usr/share/enlightenment/epplet_icons
	EBIN=${D}/usr/bin \
	EROOT=${D}/usr/share/enlightenment \
	einstall ${EBIN} ${EROOT}
	dodoc ChangeLog
}
