# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/gnu-netcat/gnu-netcat-0.7.1.ebuild,v 1.9 2005/05/16 00:51:24 vanquirius Exp $

inherit eutils toolchain-funcs flag-o-matic

DESCRIPTION="the GNU network swiss army knife"
HOMEPAGE="http://netcat.sourceforge.net/"
SRC_URI="mirror://sourceforge/netcat/netcat-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc sparc ~alpha ~arm ~hppa ~amd64 ppc-macos"
IUSE="nls debug"

DEPEND="virtual/libc"

S=${WORKDIR}/netcat-${PV}

src_compile() {
	econf \
		`use_enable nls` \
		`use_enable debug` \
		|| die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	rm ${D}/usr/bin/nc
	dodoc AUTHORS ChangeLog INSTALL NEWS README TODO
}
