# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/tux/tux-3.2.16.ebuild,v 1.1 2004/02/21 21:13:57 vapier Exp $

DESCRIPTION="kernel level httpd"
HOMEPAGE="http://people.redhat.com/mingo/TUX-patches/"
SRC_URI="http://people.redhat.com/mingo/TUX-patches/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="dev-libs/glib
	dev-libs/popt"

src_unpack() {
	unpack ${A}
	sed -i "s:-g -fomit-frame-pointer -O2:${CFLAGS}:" ${S}/Makefile
}

src_compile() {
	emake || die
}

src_install() {
	make install TOPDIR=${D} || die
	rm -rf ${D}/etc/{rc.d,sysconfig} ${D}/var/tux
	exeinto /etc/init.d ; newexe ${FILESDIR}/tux.init.d tux
	insinto /etc/conf.d ; newins ${FILESDIR}/tux.conf.d tux

	dodoc NEWS SUCCESS tux.README docs/*.txt
	docinto samples
	dodoc samples/* demo*.c
}
