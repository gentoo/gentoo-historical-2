# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/flex/flex-2.5.4a-r5.ebuild,v 1.26 2004/09/16 06:36:40 robmoss Exp $

inherit eutils

DESCRIPTION="GNU lexical analyser generator"
HOMEPAGE="http://lex.sourceforge.net/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="FLEX"
SLOT="0"
KEYWORDS="x86 ppc sparc mips alpha arm hppa amd64 ia64 ppc64 s390 macos ppc-macos"
IUSE="build static"

DEPEND="virtual/libc"

S="${WORKDIR}/${P/a/}"

src_unpack() {
	unpack ${A}

	cd ${S}
	# Some Redhat patches to fix various problems
	epatch ${FILESDIR}/flex-2.5.4-glibc22.patch
	epatch ${FILESDIR}/flex-2.5.4a-gcc3.patch
	epatch ${FILESDIR}/flex-2.5.4a-gcc31.patch
	epatch ${FILESDIR}/flex-2.5.4a-skel.patch
}

src_compile() {

	./configure \
		--prefix=/usr \
		--host=${CHOST} \
		|| die

	if use static
	then
		emake -j1 LDFLAGS=-static || die "emake failed"
	else
		emake -j1 || die "emake failed"
	fi
}

src_test() {
	cd ${S}
	make bigtest
}

src_install() {
	make -j1 prefix=${D}/usr \
		mandir=${D}/usr/share/man/man1 \
		install || die "make install failed"

	if use build
	then
		rm -rf ${D}/usr/share ${D}/usr/include ${D}/usr/lib
	else
		dodoc NEWS README
	fi

	dosym flex /usr/bin/lex
}
