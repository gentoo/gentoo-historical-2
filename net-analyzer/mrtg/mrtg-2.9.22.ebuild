# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/mrtg/mrtg-2.9.22.ebuild,v 1.3 2003/02/13 13:42:59 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A tool to monitor the traffic load on network-links"
SRC_URI="http://ee-staff.ethz.ch/~oetiker/webtools/mrtg/pub/${P}.tar.gz"
HOMEPAGE="http://ee-staff.ethz.ch/~oetiker/webtools/mrtg/"

KEYWORDS="x86 ~ppc sparc"
LICENSE="GPL-2"
SLOT="0"

DEPEND="virtual/glibc
	sys-devel/perl
	>=media-libs/libgd-1.8.3"
#	>=media-libs/libpng-1.2.1"

src_compile() {
	./configure --prefix=/usr --host=${CHOST} || die
	emake || die
}

src_install () {
	make prefix=${D}/usr install || die
	dodir /usr/share/man
	mv ${D}/usr/man/man1 ${D}/usr/share/man
	rm -rf ${D}/usr/{man,doc}
	dodoc ANNOUNCE COPYING CHANGES COPYRIGHT MANIFEST README THANKS
	docinto txt ; dodoc doc/*.txt
	cp -a contrib ${D}/usr/share/doc/${PF}/contrib
	prepalldocs
	docinto html ; dohtml -r doc/* images/*
}
