# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/fortune-mod-thomas-ogrisegg/fortune-mod-thomas-ogrisegg-20030120.ebuild,v 1.1 2004/10/08 12:50:44 hansmi Exp $

S="${WORKDIR}/fortune-mod-thomas.ogrisegg-${PV}"

DESCRIPTION="Quotes from Thomas Ogrisegg"
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
	doins thomas.ogrisegg thomas.ogrisegg.dat
}
