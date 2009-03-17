# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/fortune-mod-discworld/fortune-mod-discworld-0.1.ebuild,v 1.1 2009/03/17 14:32:07 s4t4n Exp $

MY_P=${PN/-mod/}
DESCRIPTION="Quotes from Discworld novels"
HOMEPAGE="http://www.splitbrain.org/projects/fortunes/discworld"
SRC_URI="http://www.splitbrain.org/_media/projects/fortunes/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="games-misc/fortune-mod"

S=${WORKDIR}/${MY_P}

src_install() {
	insinto /usr/share/fortune
	doins discworld discworld.dat || die
}
