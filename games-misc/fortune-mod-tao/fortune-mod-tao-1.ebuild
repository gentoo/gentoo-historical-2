# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/fortune-mod-tao/fortune-mod-tao-1.ebuild,v 1.13 2006/07/19 20:01:39 flameeyes Exp $

MY_PN=${PN/mod-/}
DESCRIPTION="set of fortunes based on the Tao-Teh-Ching"
HOMEPAGE="http://fortunes.quotationsbook.com/fortunes/collection/67/TAO"
SRC_URI="mirror://gentoo/${MY_PN}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="games-misc/fortune-mod"

S=${WORKDIR}/${MY_PN}

src_install() {
	insinto /usr/share/fortune
	doins tao tao.dat || die
}
