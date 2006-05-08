# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/cidr/cidr-2.3.1-r1.ebuild,v 1.9 2006/05/08 21:05:23 dertobi123 Exp $

inherit eutils

DESCRIPTION="command line util to assist in calculating subnets"
HOMEPAGE="http://home.netcom.com/~naym/cidr/"
SRC_URI="http://home.netcom.com/~naym/cidr/cidr-current.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc sparc x86"
IUSE=""

DEPEND=""

S=${WORKDIR}/${PN}-2.3

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}.patch
}

src_compile() {
	emake || die "make failed"
}

src_install() {
	dobin cidr
	dodoc README ChangeLog
	doman cidr.1
}
