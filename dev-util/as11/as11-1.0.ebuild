# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/as11/as11-1.0.ebuild,v 1.4 2004/07/02 05:03:16 eradicator Exp $

DESCRIPTION="Motorola's AS11 Assembler for the 68HC11"
HOMEPAGE="http://www.ai.mit.edu/people/rsargent/as11.html"
SRC_URI="http://www.ai.mit.edu/people/rsargent/source/${PN}_src.tar.gz"
LICENSE="freedist"

SLOT="0"
KEYWORDS="~x86"
IUSE=""

S=${WORKDIR}/${PN}

DEPEND="virtual/libc"
RDEPEND=""

src_compile() {
	emake || die "Compile failed"
}

src_install() {
	dobin as11
	dodoc as11.doc CHANGELOG README
}

