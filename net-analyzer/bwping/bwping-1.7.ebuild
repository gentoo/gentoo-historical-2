# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/bwping/bwping-1.7.ebuild,v 1.2 2013/01/27 13:15:41 ago Exp $

EAPI=5

inherit autotools

DESCRIPTION="A tool to measure bandwidth and RTT between two hosts using ICMP"
HOMEPAGE="http://bwping.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

src_prepare() {
	eautoreconf
}

src_install () {
	dosbin ${PN}
	doman  ${PN}.8
	dodoc  ChangeLog README
}
