# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/gmp/gmp-4.1-r1.ebuild,v 1.22 2004/06/24 23:11:39 agriffis Exp $

inherit eutils

DESCRIPTION="Library for arithmetic on arbitrary precision integers, rational numbers, and floating-point numbers"
HOMEPAGE="http://www.gnu.org/software/gmp/gmp.html"
SRC_URI="ftp://prep.ai.mit.edu/gnu/gmp/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha"
IUSE=""

DEPEND=">=sys-devel/m4-1.4"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/randraw.c.41.diff
}

src_compile() {
	local myconf=""
	[ "${ARCH}" != "sparc" ] && myconf="--enable-mpfr"
	econf \
		--localstatedir=/var/state/gmp \
		--enable-cxx \
		--enable-mpbsd \
		--disable-fft \
		${myconf} \
		|| die "configure failed"

	make || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc AUTHORS ChangeLog NEWS README
	dodoc doc/configuration doc/isa_abi_headache
	dohtml -r doc
}
