# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/netpipes/netpipes-4.2.ebuild,v 1.3 2008/11/08 13:14:40 cedk Exp $

inherit toolchain-funcs eutils

DESCRIPTION="netpipes - a package to manipulate BSD TCP/IP stream sockets"
HOMEPAGE="http://web.purplefrog.com/~thoth/netpipes/"
SRC_URI="http://web.purplefrog.com/~thoth/netpipes/ftp/${P}-export.tar.gz"
LICENSE="GPL-2"

SLOT="0"
# theoretically you should be able to build netpipes on ANY architecture
KEYWORDS="~amd64 x86"
IUSE=""

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i \
		-e "s/CFLAGS =/CFLAGS +=/" \
		Makefile || die "sed failed"

	epatch "${FILESDIR}/${P}-string.patch"
}

src_compile () {
	emake CC=$(tc-getCC) || die
}

src_install() {
	mkdir -p "${D}"/usr/share/man || die
	emake INSTROOT="${D}"/usr INSTMAN="${D}"/usr/share/man install || die
}
