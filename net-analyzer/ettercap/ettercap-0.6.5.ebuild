# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Bruce Locke <blocke@shivan.org>
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/ettercap/ettercap-0.6.5.ebuild,v 1.1 2002/04/28 03:15:39 blocke Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Ettercap is a multipurpose sniffer/interceptor/logger for switched LAN."
SRC_URI="http://ettercap.sourceforge.net/download/${P}.tar.gz"
HOMEPAGE="http://ettercap.sourceforge.net"

DEPEND="sys-libs/ncurses	ssl? ( dev-libs/openssl )"

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



