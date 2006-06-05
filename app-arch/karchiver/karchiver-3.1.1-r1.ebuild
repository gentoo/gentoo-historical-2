# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/karchiver/karchiver-3.1.1-r1.ebuild,v 1.6 2006/06/05 22:55:34 flameeyes Exp $

inherit kde

DESCRIPTION="Utility to ease working with compressed files such as tar.gz/tar.bz2"
HOMEPAGE="http://perso.wanadoo.fr/coquelle/karchiver/"
SRC_URI="http://perso.wanadoo.fr/coquelle/karchiver/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ppc sparc x86"
SLOT="0"
IUSE=""

need-kde 3.1

PATCHES="${FILESDIR}/${P}-gcc41.patch"

# Nasty packaging...
src_unpack() {
	kde_src_unpack
	rm -rf karchiver/.libs
	rm -f karchiver/*.l[ao] karchiver/*.o
	rm -f config.log config.status
}

# ...continued.
src_install() {
	kde_src_install
	rm -rf ${D}/usr/share/applnk-mdk
}

