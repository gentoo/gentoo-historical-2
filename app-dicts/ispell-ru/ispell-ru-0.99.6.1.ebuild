# Copyright 2002 Arcady Genkin <agenkin@thpoon.com>
# Distributed under the terms of the GNU General Public License, v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/ispell-ru/ispell-ru-0.99.6.1.ebuild,v 1.1 2002/12/03 07:15:39 seemant Exp $

MY_PV=${PV/.6./f}
S="${WORKDIR}"
DESCRIPTION="Alexander I. Lebedev's Russian dictionary for ispell."
HOMEPAGE="http://fmg-www.cs.ucla.edu/geoff/ispell-dictionaries.html#Russian-dicts"
SRC_URI="http://www.ibiblio.org/pub/Linux/distributions/gentoo/distfiles/rus-ispell-${MY_PV}.tar.gz"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86"

DEPEND="app-text/ispell"

src_compile() {
	make || die
}

src_install () {
	insinto /usr/lib/ispell
	doins russian.hash russian.aff

	#what do these do??
#	exeinto /usr/lib/ispell-ru
#	doexe sortkoi8 trans
	dodoc README README.koi LICENSE
}
