# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/mdsplib/mdsplib-0.11.ebuild,v 1.4 2007/07/12 02:25:35 mr_bones_ Exp $

DESCRIPTION="METAR Decoder Software Package Library"
HOMEPAGE="http://limulus.net/mdsplib/"
SRC_URI="http://limulus.net/mdsplib/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc"
IUSE=""
DEPEND="virtual/libc"
RDEPEND="virtual/libc"

src_compile() {
	emake -e all || die "make failed"
}

src_install() {
	insinto /usr/include
	insopts -m0644
	newins ${S}/metar.h metar.h
	insinto /usr/lib
	insopts -m0644
	newins ${S}/libmetar.a libmetar.a
	dodoc README README.MDSP
	dobin dmetar
}
