# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-libs/mm/mm-1.2.1.ebuild,v 1.3 2002/08/14 10:16:05 pvdabeel Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Shared Memory Abstraction Library"
HOMEPAGE="http://www.ossp.org/pkg/lib/mm/"
SRC_URI="ftp://ftp.ossp.org/pkg/lib/mm/${P}.tar.gz"
DEPEND="virtual/glibc"
LICENSE="as-is"
SLOT="1.2"
KEYWORDS="x86 ppc"

inherit libtool

src_unpack() {
	unpack ${A}
	cd ${S}
}

src_compile() {
	elibtoolize
	econf --host=${CHOST} || die "bad ./configure"
	make || die "compile problem"
	make test || die "testing problem"
}

src_install() {
	einstall || die
	dodoc README LICENSE ChangeLog INSTALL PORTING THANKS

	dosym /usr/lib/libmm.so /usr/lib/libmm.so.1
}
