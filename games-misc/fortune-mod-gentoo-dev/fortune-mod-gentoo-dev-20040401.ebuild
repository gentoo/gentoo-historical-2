# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/fortune-mod-gentoo-dev/fortune-mod-gentoo-dev-20040401.ebuild,v 1.2 2004/05/04 00:21:18 mr_bones_ Exp $

DESCRIPTION="Fortune database of #gentoo-dev quotes"
HOMEPAGE="http://oppresses.us/~avenj/index.html"
SRC_URI="http://oppresses.us/~avenj/files/gentoo-dev/gentoo-dev-${PV}.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc mips alpha hppa amd64"
IUSE=""

RDEPEND="games-misc/fortune-mod"

S="${WORKDIR}"

src_compile () {
	mv gentoo-dev-${PV} gentoo-dev
	strfile gentoo-dev
}

src_install () {
	insinto /usr/share/fortune
	doins gentoo-dev gentoo-dev.dat
}
