# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/fortune-mod-dune/fortune-mod-dune-2.0.1.ebuild,v 1.3 2004/06/24 22:54:49 agriffis Exp $

MY_P=${PN}-quotes.${PV}
DESCRIPTION="Quotes from Frank Herbert's Dune Chronicles"
HOMEPAGE="http://dune.s31.pl/"
SRC_URI="http://dune.s31.pl/${MY_P}.tar.gz"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="x86 ppc sparc mips alpha hppa amd64"

RDEPEND="games-misc/fortune-mod"

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto /usr/share/fortune
	doins *
}
