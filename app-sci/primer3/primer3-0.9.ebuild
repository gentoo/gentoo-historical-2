# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/primer3/primer3-0.9.ebuild,v 1.3 2004/06/24 22:15:28 agriffis Exp $

DESCRIPTION="Design primers for PCR reactions."
HOMEPAGE="http://frodo.wi.mit.edu/primer3/primer3_code.html"
SRC_URI="http://frodo.wi.mit.edu/primer3/primer3_0_9_test.tar.gz"
LICENSE="whitehead"

SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

S=${WORKDIR}/${PN}_0_9_test/src

src_compile() {
	emake || die
}

src_install () {
	dobin primer3_core
	dodoc release_notes ../README ../example
}
