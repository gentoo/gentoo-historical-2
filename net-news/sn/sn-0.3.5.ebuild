# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-news/sn/sn-0.3.5.ebuild,v 1.1 2003/01/01 02:08:41 vapier Exp $

DESCRIPTION="Hassle-free Usenet news system for small sites"
SRC_URI="http://infa.abo.fi/~patrik/sn/files/${P}.tar.gz"
HOMEPAGE="http://infa.abo.fi/~patrik/sn/"

KEYWORDS="x86"
SLOT="0"
LICENSE="GPL-2"

DEPEND="sys-libs/glibc
	sys-libs/zlib"

src_compile() {
	emake \
		SNROOT=/var/spool/news \
		BINDIR=/usr/sbin \
		MANDIR=/usr/share/man \
		|| die "emake failed"
}

src_install() {
	dodir /var/spool/news /usr/sbin /usr/share/man/man8
	mknod -m 600 ${D}/var/spool/news/.fifo p
	make install \
		SNROOT=${D}/var/spool/news \
		BINDIR=${D}/usr/sbin \
		MANDIR=${D}/usr/share/man \
		|| die "make install failed"
	dodoc COPYING FAQ INSTALL* INTERNALS README* THANKS TODO
}

pkg_postinst() {
	chown news:news /var/spool/news
	chown news:news /var/spool/news/.fifo
}
