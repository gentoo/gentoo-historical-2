# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/xmlwrapp/xmlwrapp-0.4.4.ebuild,v 1.1 2004/02/21 11:40:12 usata Exp $

DESCRIPTION="modern style C++ library that provides a simple and easy interface to libxml2"
SRC_URI="http://pmade.org/software/xmlwrapp/download/${P}.tar.gz"
HOMEPAGE="http://pmade.org/software/xmlwrapp/"

KEYWORDS="~x86 ~ppc"
LICENSE="BSD"
SLOT="0"

DEPEND="virtual/glibc
	dev-lang/perl
	dev-libs/libxml2
	dev-libs/libxslt"

src_unpack() {

	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PN}-gentoo.diff
}

src_compile() {

	perl configure.pl --prefix /usr || die
	emake || die
}

src_install() {

	sed -i "s%/usr%${D}/usr%g" Makefile
	make install || die

	dodoc README docs/{CREDITS,TODO,VERSION}
	cd docs
	for doc in {manual,project} ; do
		insinto /usr/share/doc/${PF}/$doc
		doins $doc/*.xml
	done
}
