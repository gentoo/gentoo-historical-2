# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/ettercap/ettercap-0.6.7.ebuild,v 1.8 2003/02/13 13:40:13 vapier Exp $

IUSE="ssl"

S=${WORKDIR}/${P}
DESCRIPTION="Ettercap is a multipurpose sniffer/interceptor/logger for switched LAN."
SRC_URI="http://ettercap.sourceforge.net/download/${P}.tar.gz"
HOMEPAGE="http://ettercap.sourceforge.net"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc alpha"

DEPEND="sys-libs/ncurses
	ssl? ( dev-libs/openssl )"

src_compile() {
	local myconf
	use ssl && myconf="${myconf} --enable-https"

	./configure --host=${CHOST} --prefix=/usr --enable-ncurses --enable-plugins ${myconf}
	assert

	make CFLAG="${CFLAGS} -funroll-loops -fomit-frame-pointer -Wall" || die
	make CFLAG="${CFLAGS} -funroll-loops -fomit-frame-pointer -Wall" plug-ins || die
}

src_install() {                               

	make prefix=${D}/usr MANDIR=${D}/usr/share/man complete_install || die
	rm ${D}/usr/share/doc/${P}/ettercap.fr.8.in.gz
	gzip ${D}/usr/share/doc/${P}/*

}



