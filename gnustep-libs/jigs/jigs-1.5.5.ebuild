# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-libs/jigs/jigs-1.5.5.ebuild,v 1.1 2004/07/23 13:36:49 fafhrd Exp $

inherit gnustep-old

S=${WORKDIR}/${PN}

DESCRIPTION="GNUstep java bridge"
HOMEPAGE="http://www.gnustep.org"
SRC_URI="http://www.gnustep.it/jigs/Download/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
DEPEND=">=dev-util/gnustep-gui-0.8.5"
IUSE=""

src_compile() {
	addwrite ~/GNUstep/Library/Services/.GNUstepAppList
	egnustepmake
}
