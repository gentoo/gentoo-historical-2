# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/labrea/labrea-2.5.ebuild,v 1.2 2004/07/05 16:38:36 dholm Exp $

DESCRIPTION="'Sticky' Honeypot and IDS"
HOMEPAGE="http://labrea.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-stable-1.tar.gz"
RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""
DEPEND="net-libs/libpcap
	>=dev-libs/libdnet-1.7"

MY_P="${P}-stable-1"
S=${WORKDIR}/${MY_P}

src_compile() {
	econf || die
	emake || die
}

src_install() {
	einstall || die "einstall failed"
	dodoc AUTHORS ChangeLog INSTALL README TODO NEWS
}

pkg_postinst() {

	ewarn CAUTION:
	ewarn Before using this package READ the INSTALL and README!
	ewarn as the author states that it can cause serious problems on your network.

}
