# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/sarg/sarg-1.4.1-r2.ebuild,v 1.6 2004/12/18 19:11:26 jhhudso Exp $

inherit eutils

DESCRIPTION="Sarg (Squid Analysis Report Generator) is a tool that allows you to view where your users are going to on the Internet."
HOMEPAGE="http://web.onda.com.br/orso/sarg.html"
SRC_URI="http://web.onda.com.br/orso/${P}.tar.gz http://web.onda.com.br/orso/patches/sarg-1.4.1-index.sort.patch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=""
RDEPEND=">=www-proxy/squid-2.5.1"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${DISTDIR}/sarg-1.4.1-index.sort.patch
	epatch ${FILESDIR}/sarg-1.4.1-2.6.fix.patch
}

src_compile() {
	rm -rf config.cache
	./configure \
		--enable-bindir=/usr/bin \
		--enable-mandir=/usr/man/man1 \
		--enable-sysconfdir=/etc/sarg || die "./configure failed"
	emake || die
}

src_install() {
	dodir /etc/sarg /usr/bin /usr/man/man1
	make \
		BINDIR=${D}/usr/bin \
		MANDIR=${D}/usr/man/man1 \
		SYSCONFDIR=${D}/etc/sarg \
		install || die
}
