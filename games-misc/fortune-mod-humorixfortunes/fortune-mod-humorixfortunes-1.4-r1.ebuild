# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/fortune-mod-humorixfortunes/fortune-mod-humorixfortunes-1.4-r1.ebuild,v 1.12 2010/01/03 11:59:49 fauli Exp $

MY_P=${P/fortune-mod-/}
DESCRIPTION="Extra fortune cookies for fortune"
HOMEPAGE="http://i-want-a-website.com/about-linux/downloads.shtml"
SRC_URI="http://humorix.org/downloads/${MY_P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

RDEPEND="games-misc/fortune-mod"

S=${WORKDIR}/${MY_P}

src_install() {
	insinto /usr/share/fortune
	doins humorix-misc humorix-misc.dat || die
	doins humorix-stories humorix-stories.dat || die
}
