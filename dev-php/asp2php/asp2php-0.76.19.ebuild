# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/asp2php/asp2php-0.76.19.ebuild,v 1.5 2004/05/30 23:14:53 kloeri Exp $

inherit eutils

IUSE=""
DESCRIPTION="ASP to PHP translator"
SRC_URI="http://www.mikekohn.com/asp2php/${P}.tar.gz"
HOMEPAGE="http://asp2php.naken.cc/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc alpha amd64"

src_unpack() {
	unpack ${P}.tar.gz
	cd ${S}
	epatch ${FILESDIR}/${P}-makefile.patch
}

src_compile() {
	emake || die
}

src_install() {
	dodir /usr/bin
	make DESTDIR="${D}" install || die

	dodoc LICENSE README
	docinto sample
	dodoc sample/class_test.asp sample/filesystem.asp sample/mailer-test.asp sample/testfile.asp
}

