# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/pnglite/pnglite-0.1.17.ebuild,v 1.1 2010/03/24 23:33:57 volkmar Exp $

EAPI="2"

inherit eutils flag-o-matic multilib toolchain-funcs

DESCRIPTION="Small and simple library for loading and writing PNG images"
HOMEPAGE="http://www.karlings.com/~danne/pnglite/"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~x86"
IUSE="static-libs"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}

src_prepare() {
	epatch "${FILESDIR}"/${P}-include-stdio.patch
	sed -ie "s:\"../zlib/zlib.h\":<zlib.h>:" pnglite.c || die "sed failed"
}

src_compile() {
	if use static-libs; then
		emake ${PN}.o || die "make failed"
		ar -cvq lib${PN}.a ${PN}.o || die "ar failed"
		rm ${PN}.o || die "rm failed"
	fi

	append-flags -fPIC
	emake ${PN}.o || die "make failed"
	$(tc-getCC) ${LDFLAGS} -shared -Wl,-soname,lib${PN}.so.0 \
		-o lib${PN}.so.0 ${PN}.o -lz || die "creating so file failed"
}

src_install() {
	insinto /usr/include
	doins ${PN}.h

	dolib.so lib${PN}.so.0 || die "dolib failed"
	if use static-libs; then
		dolib.a lib${PN}.a || die "dolib failed"
	fi

	dosym lib${PN}.so.0 /usr/$(get_libdir)/lib${PN}.so \
		|| die "dosym failed"
}
