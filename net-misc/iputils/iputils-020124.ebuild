# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# Maintainer: Grant Goodyear <g2boojum@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-misc/iputils/iputils-020124.ebuild,v 1.8 2003/07/16 14:27:38 pvdabeel Exp $

S="${WORKDIR}/${PN}"
DESCRIPTION="Network monitoring tools including ping and ping6"
SRC_URI="ftp://ftp.inr.ac.ru/ip-routing/${PN}-ss${PV}.tar.gz"
HOMEPAGE="ftp://ftp.inr.ac.ru/ip-routing"
LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 sparc mips ppc"

DEPEND="virtual/glibc
		app-text/openjade
		dev-perl/SGMLSpm
		app-text/docbook-sgml-dtd
		app-text/docbook-sgml-utils"

src_compile() {
	make || die
	# can't get the html to build ; missing dep?
	 make html || die
	make man || die
}

src_install () {
	dosbin clockdiff arping ipg ping ping6 rarpd rdisc tftpd
	dosbin tracepath tracepath6 traceroute6
	dodoc INSTALL RELNOTES
	doman doc/*.8
}
