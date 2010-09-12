# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-radio/ibp/ibp-0.21.ebuild,v 1.1 2010/09/12 11:15:53 tomjbe Exp $

DESCRIPTION="Shows currently transmitting beacons of the International Beacon Project (IBP)"
HOMEPAGE="http://wwwhome.cs.utwente.nl/~ptdeboer/ham/${PN}.html"
SRC_URI="http://wwwhome.cs.utwente.nl/~ptdeboer/ham/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X"

RDEPEND="sys-libs/ncurses
	X? ( x11-libs/libX11  )"
DEPEND="${RDEPEND}
	X? ( x11-misc/imake )"

src_compile() {
	if ( use X ) ;then
		xmkmf || die " xmkmf failed"
	fi
	emake || die
}

src_install() {
	dobin ${PN} || die
	doman ${PN}.1 || die
}
