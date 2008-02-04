# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/fortune-mod-gentoo-forums/fortune-mod-gentoo-forums-20041207.ebuild,v 1.8 2008/02/04 19:08:57 nyhm Exp $

DESCRIPTION="Fortune database of quotes from forums.gentoo.org"
HOMEPAGE="http://forums.gentoo.org/"
SRC_URI="mirror://gentoo/gentoo-forums-${PV}.gz
	offensive? ( mirror://gentoo/gentoo-forums-offensive-${PV}.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="offensive"

DEPEND="games-misc/fortune-mod"

S=${WORKDIR}

src_compile() {
	mv gentoo-forums-${PV} gentoo-forums || die
	use offensive && cat gentoo-forums-offensive-${PV} >> gentoo-forums
	strfile gentoo-forums || die
}

src_install() {
	insinto /usr/share/fortune
	doins gentoo-forums gentoo-forums.dat || die
}
