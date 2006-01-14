# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/argus-clients/argus-clients-2.0.6.ebuild,v 1.2 2006/01/14 10:30:24 dertobi123 Exp $

DESCRIPTION="Clients for net-analyzer/argus"
HOMEPAGE="http://www.qosient.com/argus/"
SRC_URI="ftp://ftp.qosient.com/pub/argus/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

RDEPEND="virtual/libc
	virtual/libpcap
	>=net-analyzer/argus-2.0.6"

DEPEND="${RDEPEND}
	>=sys-devel/bison-1.28
	>=sys-devel/flex-2.4.6"

src_install() {
	# argus_parse.a and argus_common.a are supplied by net-analyzer/argus
	dolib lib/argus_client.a
	dobin bin/ra*

	dodoc ChangeLog CREDITS README

	#do not install man/man1/tcpdump.1, file collision
	rm man/man1/tcpdump.1
	doman man/man{1,5}/*
}
