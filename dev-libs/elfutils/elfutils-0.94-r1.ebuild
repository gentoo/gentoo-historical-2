# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/elfutils/elfutils-0.94-r1.ebuild,v 1.4 2004/04/11 11:27:52 cretin Exp $

inherit eutils

DESCRIPTION="Libraries/utilities to handle ELF objects (drop in replacement for libelf)"
HOMEPAGE="http://www.redhat.com/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="OpenSoftware"
SLOT="0"
KEYWORDS="x86 sparc amd64 ppc alpha"
IUSE="nls"

DEPEND=">=sys-libs/glibc-2.3.2
	>=sys-devel/binutils-2.14.90.0.6
	>=sys-devel/gcc-3.2.1-r6
	!dev-libs/libelf"

src_unpack() {
	unpack ${A}

	for x in $(find ${S}/ -name Makefile.in) ; do
		cp ${x} ${x}.orig
		sed -e 's:-Werror::g' \
		${x}.orig > ${x}
	done
}

src_compile() {
	econf \
		--program-prefix="eu-" \
		--enable-shared \
		`use_enable nls` \
		|| die "./configure failed"
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	# Remove stuff we do not use ...
	rm -f ${D}/usr/bin/eu-ld
	rm -f ${D}/usr/include/elfutils/lib{asm,dw,dwarf}.h
	# Utils need libdw ...
	#rm -f ${D}/usr/lib/lib{asm,dw}-${PV}.so
	#rm -f ${D}/usr/lib/lib{asm,dw}.so*
	rm -f ${D}/usr/lib/{libasm.so*,libasm-${PV}.so}
	rm -f ${D}/usr/lib/lib{asm,dw,dwarf}.a
	rm -rf ${D}/usr/usr

	dodoc AUTHORS COPYING ChangeLog NEWS NOTES README THANKS TODO
}
