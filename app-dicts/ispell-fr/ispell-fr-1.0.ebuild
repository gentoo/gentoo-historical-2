# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/ispell-fr/ispell-fr-1.0.ebuild,v 1.3 2002/12/15 10:44:10 bjb Exp $

MY_P="Francais-GUTenberg-v${PV}"
S=${WORKDIR}/${MY_P}
DESCRIPTION="French dictionnary for ispell"
SRC_URI="http://www.unil.ch/ling/cp/${MY_P}.tar.gz"
HOMEPAGE="http://www.unil.ch/ling/cp/frgut.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc alpha"

DEPEND="app-text/ispell"

src_compile() {
	cat dicos/*.dico | sort > francais.dico
	buildhash francais.dico francais.aff francais.hash || die
	buildhash francais.dico francais-TeX8b.aff francais-TeX8b.hash || die
}

src_install () {
	insinto /usr/lib/ispell
	doins francais.aff francais.hash francais-TeX8b.aff francais-TeX8b.hash
}
