# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/isic/isic-0.05-r1.ebuild,v 1.7 2004/07/10 12:12:19 eldad Exp $

inherit eutils

DESCRIPTION="IP Stack Integrity Checker"
HOMEPAGE="http://www.packetfactory.net/projects/ISIC/"
SRC_URI="http://www.packetfactory.net/projects/ISIC/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86"
IUSE=""

RDEPEND="<net-libs/libnet-1.1
	>=net-libs/libnet-1.0.2a-r3"

DEPEND="$RDEPEND >=sys-devel/autoconf-2.58"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PV}-libnet-1.0.patch
	env WANT_AUTOCONF=2.5 autoconf || die
}

src_compile() {
	econf || die
	emake || die
}

src_install() {
	make install PREFIX=${D}/usr || die
	dodoc README
}
