# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/sniffit/sniffit-0.3.7-r2.ebuild,v 1.1 2010/09/16 16:31:59 jer Exp $

EAPI="2"

inherit eutils toolchain-funcs

MY_P="${P/-/.}.beta"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Interactive Packet Sniffer"
SRC_URI="http://reptile.rug.ac.be/~coder/${PN}/files/${MY_P}.tar.gz
	 mirror://debian/pool/main/s/${PN}/${PN}_0.3.7.beta-15.diff.gz"
HOMEPAGE="http://reptile.rug.ac.be/~coder/sniffit/sniffit.html"

DEPEND="net-libs/libpcap
	>=sys-libs/ncurses-5.2"

SLOT="0"
LICENSE="as-is"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

src_prepare() {
for i in *.c *.h Makefile.in; do cp -av $i $i.orig; done
	epatch \
		${WORKDIR}/${PN}_0.3.7.beta-15.diff \
		${PN}-0.3.7.beta/debian/patches/

	epatch \
		${FILESDIR}/${P}-flags.patch \
		${FILESDIR}/${P}-misc.patch
}

src_configure() {
	tc-export CC
	econf || die
}

src_install () {
	dobin sniffit

	doman sniffit.5 sniffit.8
	dodoc README* PLUGIN-HOWTO BETA* HISTORY LICENSE
}
