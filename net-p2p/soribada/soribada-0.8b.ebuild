# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-p2p/soribada/soribada-0.8b.ebuild,v 1.2 2002/07/11 06:30:49 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Soribada (korean napster clone) client for linux"
SRC_URI="http://soribada.kldp.org/depot/${P}.tar.gz"
HOMEPAGE="http://soribada.kldp.org"
DEPEND="virtual/x11
	>=x11-libs/gtk+-1.2.0"
SLOT="0"

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--bindir=/usr/bin || die "./configure failed"

	emake || die
}

src_install() {
	make	\
		prefix=${D}/usr \
		bindir=${D}/usr/bin \
		install || die

	dodoc ABOUT-NLS AUTHORS COPYING ChangeLog INSTALL README NEWS TODO
}
