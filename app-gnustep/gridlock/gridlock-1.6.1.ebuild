# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-gnustep/gridlock/gridlock-1.6.1.ebuild,v 1.5 2004/06/24 21:40:46 agriffis Exp $

inherit gnustep

S=${WORKDIR}/${PN/g/G}

DESCRIPTION="Gridlock is a collection of grid-based games"
HOMEPAGE="http://dozingcat.com/"
SRC_URI="http://dozingcat.com/Gridlock/${PN/g/G}-GNUstep-${PV}.tar.gz"
IUSE=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"

DEPEND=">=dev-util/gnustep-gui-0.8.5"

src_unpack() {
	unpack ${PN/g/G}-GNUstep-${PV}.tar.gz
	cd ${S}
}
