# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/iplog/iplog-2.2.3.ebuild,v 1.9 2002/08/14 12:12:05 murphy Exp $


S=${WORKDIR}/${P}
DESCRIPTION="iplog is a TCP/IP traffic logger"
SRC_URI="mirror://sourceforge/ojnk/${P}.tar.gz"
HOMEPAGE="http://ojnk.sourceforge.net/"

DEPEND="net-libs/libpcap"

SLOT="0"
LICENSE="GPL-2 | FDL-1.1"
KEYWORDS="x86 ppc sparc sparc64"

src_compile() {

	econf || die
	make CFLAGS="${CFLAGS} -D_REENTRANT" all || die

}

src_install() {

	make \
		prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		install || die

	dodoc AUTHORS COPYING.* NEWS README TODO example-iplog.conf
}

