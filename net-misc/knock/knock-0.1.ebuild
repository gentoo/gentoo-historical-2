# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/knock/knock-0.1.ebuild,v 1.12 2005/03/14 17:49:52 pyrania Exp $

inherit eutils

DESCRIPTION="A simple port-knocking daemon"
HOMEPAGE="http://www.zeroflux.org/knock/"
SRC_URI="http://www.zeroflux.org/knock/${P}.tar.gz"

DEPEND="virtual/libpcap"

KEYWORDS="x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/nonblock.patch
	epatch ${FILESDIR}/knockd.conf.patch
}

src_compile() {
	econf || die "could not configure"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc README
	dohtml doc/index.html

	insinto /etc/conf.d; newins ${FILESDIR}/knockd.confd knock
	exeinto /etc/init.d; newexe ${FILESDIR}/knockd.initd knock
}
