# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-lang/mono/mono-0.13.ebuild,v 1.2 2002/07/28 17:48:40 sunflare Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Mono runtime"
SRC_URI="http://www.go-mono.com/archive/${P}.tar.gz"
HOMEPAGE="http://www.go-mono.com/"

LICENSE="GPL-2"
SLOT="0"

DEPEND="virtual/glibc
        dev-util/pkgconfig"
RDEPEND="${DEPEND}"
KEYWORDS="x86 -ppc"

src_compile() {
	./configure \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info || die "./configure failed"
	MAKEOPTS="-j1" emake || die
}

src_install () {
	make \
		prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		install || die

	touch ${D}/usr/include/${PN}/utils/.keep

	dodoc AUTHORS ChangeLog COPYING.LIB NEWS README
	docinto docs ; dodoc docs/gc-issues docs/jit-thoughts docs/object-layout docs/unmanaged-calls \
		docs/exceptions docs/jit-trampolines docs/stack-alignment
}
