# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/tleds/tleds-1.04-r1.ebuild,v 1.6 2003/02/13 13:51:51 vapier Exp $

IUSE="X"

S=${WORKDIR}/${P}
DESCRIPTION="Blinks keyboard LEDs (Light Emitting Diode) indicating outgoing
and incoming network packets on selected network interface."
HOMEPAGE="http://www.hut.fi/~jlohikos/tleds/"
SRC_URI="http://www.hut.fi/~jlohikos/tleds/public/${P}.tgz
	http://www.ibiblio.org/pub/Linux/distributions/gentoo/distfiles/${P}-FuRy.patch.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc "

DEPEND="X? ( virtual/x11 )"


src_unpack() {
	unpack ${P}.tgz
	cd ${S}
	bzcat ${DISTDIR}/${P}-FuRy.patch.bz2 | patch
}

src_compile() {
	emake || die
}

src_install () {
	
	dobin tleds

	use X && dobin xtleds

	doman tleds.1
	dodoc README COPYING Changes
}
