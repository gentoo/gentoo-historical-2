# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/tcc/tcc-0.9.22.ebuild,v 1.2 2005/06/02 06:22:45 wormo Exp $

IUSE=""
DESCRIPTION="A very small C compiler for ix86"
HOMEPAGE="http://www.tinycc.org/"
SRC_URI="http://fabrice.bellard.free.fr/tcc/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="-* ~x86"

DEPEND="virtual/libc"

src_compile() {
	econf || die "configure failed"
	emake || die

	# Fix examples
	for example in ex*.c; do
		tail -n +2 $example >$example.temp
		echo '#! /usr/bin/env tcc' >$example
		cat $example.temp >>$example
		chmod 755 $example
	done
}

src_install() {
	#autoconf for the package does not create dirs if they are missing for some reason
	dodir /usr/bin
	dodir /usr/lib/tcc
	dodir /usr/share/man/man1
	dodir /usr/include
	dodir /usr/share/doc/${PF}
	make prefix=${D}/usr \
		bindir=${D}/usr/bin/ \
		libdir=${D}/usr/lib/ \
		includedir=${D}/usr/include/ \
		docdir=${D}/usr/share/doc/${PF} \
		mandir=${D}/usr/share/man/ install || die
	dodoc Changelog README TODO VERSION COPYING
	dohtml tcc-doc.html
	dodir /usr/share/doc/${PF}/examples/
	insinto /usr/share/doc/${PF}/examples ; doins  ex*.c
}
