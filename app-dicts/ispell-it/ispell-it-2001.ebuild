# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/ispell-it/ispell-it-2001.ebuild,v 1.6 2004/02/22 18:26:06 agriffis Exp $

DESCRIPTION="Loris Palmerini - Italian dictionary for ispell"
HOMEPAGE="http://members.xoom.virgilio.it/trasforma/ispell/"
SRC_URI="http://members.xoom.virgilio.it/trasforma/ispell/${PN}${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc x86 sparc alpha mips hppa"

DEPEND="app-text/ispell"

S=${WORKDIR}/${PN}

src_compile() {
	make || die
}

src_install () {
	insinto /usr/lib/ispell
	doins italian.hash italian.aff

	dodoc collab.txt AUTHORS CAMBI CHANGES DA-FARE.txt FUSIONE.txt
}
