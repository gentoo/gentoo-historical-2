# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/oniguruma/oniguruma-2.2.5.ebuild,v 1.5 2004/06/24 23:30:09 agriffis Exp $

MY_DATE=20040316
MY_P="onigd${MY_DATE}"

DESCRIPTION="Regular expression library"
HOMEPAGE="http://raa.ruby-lang.org/list.rhtml?name=oniguruma"
SRC_URI="ftp://ftp.ruby-lang.org/pub/ruby/contrib/${MY_P}.tar.gz"

LICENSE="BSD"

SLOT="0"
KEYWORDS="x86 ppc"
IUSE=""

DEPEND="virtual/glibc"

S=${WORKDIR}/${PN}

src_compile() {

	econf || die
	emake || die
}

src_install() {

	dodir /usr
	make prefix=${D}/usr install || die

	dodoc HISTORY README doc/*
}
