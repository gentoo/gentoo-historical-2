# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmtimer/wmtimer-2.4.ebuild,v 1.15 2004/09/02 18:22:40 pvdabeel Exp $

IUSE=""

S=${WORKDIR}/${P}/${PN}

DESCRIPTION="Dockable clock which can run in alarm, countdown timer or chronograph mode"
SRC_URI="http://home.dwave.net/~jking/wmtimer/${P}.tar.gz"
HOMEPAGE="http://home.dwave.net/~jking/wmtimer/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64 ppc64 ppc"

RDEPEND="=x11-libs/gtk+-1.2*
	virtual/x11"

DEPEND="virtual/libc
	${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i -e "s:-O2 -Wall:${CFLAGS}:" Makefile
}

src_compile() {
	emake || die
}

src_install () {
	dobin wmtimer
	cd ..
	dodoc README COPYING INSTALL CREDITS INSTALL Changelog
}
