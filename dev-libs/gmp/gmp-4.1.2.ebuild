# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/gmp/gmp-4.1.2.ebuild,v 1.4 2003/03/09 21:41:40 agriffis Exp $

inherit flag-o-matic

DESCRIPTION="Library for arithmetic on arbitrary precision integers, rational numbers, and floating-point numbers"
HOMEPAGE="http://www.gnu.org/software/gmp/gmp.html"
SRC_URI="mirror://gnu/gmp/${P}.tar.gz"

KEYWORDS="~x86 ~ppc ~sparc alpha"
SLOT="0"
LICENSE="LGPL-2"

DEPEND=">=sys-devel/m4-1.4p"

filter-flags -ffast-math

src_compile() {                           
	local myconf=""
	use sparc || myconf="--enable-mpfr"

	econf \
		--localstatedir=/var/state/gmp \
		--enable-cxx \
		--enable-mpbsd \
		${myconf} || die "configure failed"

	emake || die "emake failed"

	# It's pretty slow to run all the checks, and not really necessary
	# on every build of this package.  Just run the checks when
	# debugging is enabled.  (23 Feb 2003 agriffis)
	if [ -n "$DEBUG" ]; then
		make check || die "make check failed"
	fi
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"

	dodoc AUTHORS ChangeLog COPYING* NEWS README
	dodoc doc/configuration doc/isa_abi_headache
	dohtml -r doc
}
