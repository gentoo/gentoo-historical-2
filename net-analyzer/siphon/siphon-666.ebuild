# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/siphon/siphon-666.ebuild,v 1.1.1.1 2005/11/30 10:12:15 chriswhite Exp $

IUSE=""
MY_P=${PN}-v.${PV}

DESCRIPTION="A portable passive network mapping suite"
SRC_URI="http://siphon.datanerds.net/${MY_P}.tar.gz"
HOMEPAGE="http://siphon.datanerds.net/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="~amd64 ~ppc ~sparc x86"

DEPEND="virtual/libc
	virtual/libpcap"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd ${MY_P}
	sed -i "s:osprints\.conf:/etc/osprints.conf:" log.c
	sed -i "s:^CFLAGS = .*$:CFLAGS = ${CFLAGS} -pthread -ggdb -I.:" Makefile
}

src_compile() {
	emake || die
}

src_install() {
	dobin siphon
	insinto /etc
	doins osprints.conf
	dodoc LICENSE README
}

