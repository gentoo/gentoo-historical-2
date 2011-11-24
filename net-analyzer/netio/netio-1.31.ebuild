# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/netio/netio-1.31.ebuild,v 1.1 2011/11/24 17:28:49 jer Exp $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="a network benchmarking tool that measures net throughput with NetBIOS and TCP/IP protocols."
HOMEPAGE="http://www.ars.de/ars/ars.nsf/docs/netio"
SRC_URI='http://www.ars.de/ars/ars.nsf/f24a6a0b94c22d82862566960071bf5a/aa577bc4be573b05c125706d004c75b5/$FILE/netio131.zip'

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

DEPEND="app-arch/unzip
	>=sys-apps/sed-4"
RDEPEND=""

S="${WORKDIR}"

src_prepare() {
	edos2unix *.c *.h

	sed -i Makefile \
		-e 's|\(CFLAGS\)=|\1+=|g' \
		-e 's|\(CC\)=|\1?=|g' \
		-e "s|LFLAGS=\"\"|LFLAGS?=\"${LDFLAGS}\"|g" \
		|| die "sed Makefile failed"
	epatch "${FILESDIR}"/${PN}-1.26-linux-include.patch
}

src_compile() {
	emake linux	\
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}"
}

src_install() {
	dobin netio
	dodoc netio.doc
}
