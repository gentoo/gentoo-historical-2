# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/amap/amap-2.7.ebuild,v 1.4 2004/03/21 14:04:46 mboman Exp $

DESCRIPTION="A next-generation scanning tool for pentesters"
HOMEPAGE="http://www.thc.org/releases.php"
SRC_URI="http://packetstormsecurity.nl/groups/thc/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="ssl"
DEPEND="virtual/glibc
	ssl? ( >=dev-libs/openssl-0.9.6j )"

src_unpack() {
	unpack ${A}
	cd ${S}
	# gentoo standard place for templates/configuration files
	sed -i -e '/archpath/ s:/usr/etc/:/usr/share/amap/:' amap.h
}

src_compile() {
	make || die
}

src_install() {
	local files
	files="appdefs.trig appdefs.resp appdefs.rpc"

	# the makefile is difficult to patch in a gentoo-sane way
	# easyer to install by hand
	exeinto /usr/bin
	doexe amap
	doexe amapcrap

	dodir /usr/share/${PN}
	insinto /usr/share/${PN}
	doins ${files}

	doman ${PN}.1
	dodoc README BUGS TODO CHANGES
}
