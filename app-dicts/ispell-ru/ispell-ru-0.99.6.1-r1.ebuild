# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/ispell-ru/ispell-ru-0.99.6.1-r1.ebuild,v 1.5 2004/03/14 00:50:17 mr_bones_ Exp $

MY_PV=${PV/.6./f}
S="${WORKDIR}"
DESCRIPTION="Alexander I. Lebedev's Russian dictionary for ispell."
HOMEPAGE="http://fmg-www.cs.ucla.edu/geoff/ispell-dictionaries.html#Russian-dicts"
SRC_URI="http://www.ibiblio.org/pub/Linux/distributions/gentoo/distfiles/rus-ispell-${MY_PV}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~ppc ~x86 ~sparc ~alpha ~mips ~hppa"

DEPEND="app-text/ispell"

src_compile() {
	make YO=1 || die
}

src_install () {
	insinto /usr/lib/ispell
	doins russian.hash russian.aff

	dodoc README README.koi LICENSE
}
