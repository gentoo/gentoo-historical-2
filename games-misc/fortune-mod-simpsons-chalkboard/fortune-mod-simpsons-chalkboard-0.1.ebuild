# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/fortune-mod-simpsons-chalkboard/fortune-mod-simpsons-chalkboard-0.1.ebuild,v 1.7 2004/06/24 22:56:01 agriffis Exp $

DESCRIPTION="Quotes from Bart Simpson's Chalkboard, shown at the opening of each Simpsons episode"
HOMEPAGE="http://www.splitbrain.org/index.php?x=.%2FFortunes%2Fsimpsons"
SRC_URI="http://www.splitbrain.org/Fortunes/simpsons/fortune-simpsons-chalkboard.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc mips alpha hppa amd64"
IUSE=""

RDEPEND="games-misc/fortune-mod"

S=${WORKDIR}/${PN/mod-/}

src_install() {
	insinto /usr/share/fortune
	doins chalkboard chalkboard.dat
}
