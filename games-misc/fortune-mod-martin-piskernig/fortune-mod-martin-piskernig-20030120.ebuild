# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/fortune-mod-martin-piskernig/fortune-mod-martin-piskernig-20030120.ebuild,v 1.1 2004/10/08 12:39:32 hansmi Exp $

S="${WORKDIR}/fortune-mod-martin.piskernig-${PV}"

DESCRIPTION="Quotes from Martin Piskernig"
HOMEPAGE="http://fortune-mod-fvl.sourceforge.net/"
SRC_URI="mirror://sourceforge/fortune-mod-fvl/${S}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

RDEPEND="games-misc/fortune-mod"

src_install () {
	cd "${S}"
	insinto /usr/share/fortune
	doins martin.piskernig martin.piskernig.dat
}
