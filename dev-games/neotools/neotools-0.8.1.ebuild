# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/neotools/neotools-0.8.1.ebuild,v 1.2 2004/06/24 22:13:32 agriffis Exp $

S="${WORKDIR}/neoengine-${PV}/neotools"
DESCRIPTION="Various development tools for NeoEngine"
SRC_URI="mirror://sourceforge/neoengine/neoengine-${PV}.tar.bz2"
HOMEPAGE="http://www.neoengine.org/"
LICENSE="MPL-1.1"
DEPEND=">=dev-games/neoengine-${PV}"
KEYWORDS="~ppc ~x86"
SLOT="0"
IUSE=""

src_unpack() {
	unpack ${A}

	cd ${S}
	sed -i -e 's/BUILD_STATIC/BUILD_DYNAMIC/g' configure
	for i in `find ${S} -name 'Makefile.in'`; do
		sed -i -e 's/BUILD_STATIC/BUILD_DYNAMIC/g' ${i};
		sed -i -e 's/_static//g' ${i};
	done
}

src_install () {
	einstall || die "Installation failed"

	dodoc AUTHORS ChangeLog COPYING INSTALL README TODO
}
