# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/gmp/gmp-4.1.2.ebuild,v 1.10 2004/01/30 22:24:24 agriffis Exp $

inherit flag-o-matic libtool
filter-flags -ffast-math

DESCRIPTION="Library for arithmetic on arbitrary precision integers, rational numbers, and floating-point numbers"
HOMEPAGE="http://www.gnu.org/software/gmp/gmp.html"
SRC_URI="mirror://gnu/gmp/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc alpha amd64 ia64"

DEPEND="~sys-devel/m4-1.4"

src_unpack() {
	unpack ${A}; cd ${S}
	if [ `$ARCH = "amd64"` ] ; then
	 	epatch ${FILESDIR}/longlong.patch || die
	fi
}

src_compile() {
	elibtoolize

	local myconf=""
	use sparc || myconf="--enable-mpfr"

	econf \
		--localstatedir=/var/state/gmp \
		--enable-cxx \
		--enable-mpbsd \
		${myconf} \
		|| die "configure failed"
	emake || die "emake failed"

	# It's pretty slow to run all the checks, and not really necessary
	# on every build of this package.  Just run the checks when
	# debugging is enabled.  (23 Feb 2003 agriffis)
	if [ `use debug` ] ; then
		make check || die "make check failed"
	fi
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"

	dodoc AUTHORS ChangeLog COPYING* NEWS README
	dodoc doc/configuration doc/isa_abi_headache
	dohtml -r doc
}
