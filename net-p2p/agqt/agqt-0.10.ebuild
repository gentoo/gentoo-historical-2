# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-p2p/agqt/agqt-0.10.ebuild,v 1.4 2002/07/11 06:30:49 drobbins Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="6's spiffy AudioGalaxy Query Tool"
SRC_URI="mirror://sourceforge/agqt/${P}.tar.bz2"
HOMEPAGE="http://agqt.sourceforge.net"
SLOT="0"

DEPEND="net-p2p/openag
	tcltk? ( dev-lang/tcl
		dev-lang/tk )"


src_compile() {

	make clean
	make
}

src_install() {

	dobin ag am
	use tcltk && dobin agqt.tcl

	dodoc README agrc.sample
}
