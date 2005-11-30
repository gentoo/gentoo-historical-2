# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/fortune-mod-thomas-ogrisegg/fortune-mod-thomas-ogrisegg-20030120.ebuild,v 1.1.1.1 2005/11/30 09:49:59 chriswhite Exp $

S="${WORKDIR}/fortune-mod-thomas.ogrisegg-${PV}"

DESCRIPTION="Quotes from Thomas Ogrisegg"
HOMEPAGE="http://fortune-mod-fvl.sourceforge.net/"
SRC_URI="mirror://sourceforge/fortune-mod-fvl/${S}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha hppa ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="games-misc/fortune-mod"

src_install () {
	cd "${S}"
	insinto /usr/share/fortune
	doins thomas.ogrisegg thomas.ogrisegg.dat
}
