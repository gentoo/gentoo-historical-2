# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/hugs98/hugs98-2000.12-r1.ebuild,v 1.6 2003/02/13 10:25:49 vapier Exp $

IUSE="readline"

MY_P="hugs98-Dec2001"
S=${WORKDIR}/${MY_P}
DESCRIPTION="The HUGS98 Haskell interpreter"
SRC_URI="http://cvs.haskell.org/Hugs/downloads/${MY_P}.tar.gz"
HOMEPAGE="http://www.haskell.org/hugs"

SLOT="0"
KEYWORDS="x86 sparc "
LICENSE="as-is"

DEPEND="virtual/glibc
	readline? ( >=sys-libs/readline-4.1 >=sys-libs/ncurses-5.2 )"

src_compile() {
	local myc
	use readline && myc="${myc} --with-readline" || myc="${myc} --without-readline"

	cd ${S}/src/unix || die
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		${myc} || die "./configure failed"
	cd ..
	emake || die
}

src_install () {
	cd ${S}/src || die
	make \
		prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		install || die
	dodoc Credits License Readme Install
}
