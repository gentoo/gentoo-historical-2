# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/tcpreplay/tcpreplay-3.0_beta7.ebuild,v 1.2 2006/02/16 00:05:08 jokey Exp $

MY_P=${PN}-${PV/_beta7/.beta7}
S=${WORKDIR}/${MY_P}

DESCRIPTION="replay saved tcpdump or snoop files at arbitrary speeds"
HOMEPAGE="http://tcpreplay.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
RESTRICT="nomirror"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug pcapnav"

DEPEND=">=net-libs/libnet-1.1.1
	net-libs/libpcap
	net-analyzer/tcpdump
	pcapnav? ( net-libs/libpcapnav )"

src_compile() {
	econf \
		$(use_enable debug) \
		|| die "econf failed"
	emake CFLAGS="${CFLAGS}" || die "emake failed"
}

src_test() {
	whoami
	if hasq userpriv "${FEATURES}"; then
		ewarn "Some tested disabled due to FEATURES=userpriv"
		ewarn "For a full test as root - make -C ${S}/test"
		make -C test tcpprep || die "self test failed - see ${S}/test/test.log"
	else
		make test || \
			die "self test failed - see ${S}/test/test.log"
	fi
}

src_install() {
	make DESTDIR=${D} install || die "emake install failed"
	rm ${D}/usr/bin/man2html
	dodoc docs/*
}
