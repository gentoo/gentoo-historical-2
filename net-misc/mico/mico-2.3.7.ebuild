# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/mico/mico-2.3.7.ebuild,v 1.1 2002/12/11 10:52:18 mkennedy Exp $

IUSE="ssl tcltk"

DESCRIPTION="A freely available and fully compliant implementation of the CORBA standard"
HOMEPAGE="http://www.mico.org/"
SRC_URI="http://www.mico.org/${P}.tar.gz"
LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="x86 ~alpha"

DEPEND="virtual/glibc
	sys-devel/flex
	sys-devel/bison
	ssl? ( dev-libs/openssl )
	tcltk? ( dev-lang/tcl )"

S="${WORKDIR}/${PN}"

src_compile() {
	local myopts="--enable-final 
		--disable-mini-stl 
		--enable-except
		--enable-dynamic
		--enable-repo
		--enable-shared"

	myopts="${myopts}
		--enable-life
		--enable-externalize"

	use ssl && myopts="${myopts} --with-ssl=/usr" \
		|| myopts="${myopts} --without-ssl"
	use tcltk && myopts="${myopts} --with-tcl=/usr" \
		|| myopts="${myopts} --without-tcl"

	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"

	make || die
}

src_install() {
	make INSTDIR=${D}/usr SHARED_INSTDIR=${D}/usr install || die

	dodir /usr/share/
	mv ${D}/usr/man ${D}/usr/share
	dodir /usr/share/doc/
	mv ${D}/usr/doc ${D}/usr/share/doc/${P}

	dodoc CHANGES CONVERT FAQ INSTALL LICENSE* MANIFEST README* ROADMAP TODO VERSION
}
