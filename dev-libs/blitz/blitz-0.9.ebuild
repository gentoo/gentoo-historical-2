# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/blitz/blitz-0.9.ebuild,v 1.6 2006/11/06 18:38:55 dragonheart Exp $

inherit eutils toolchain-funcs fortran

DESCRIPTION="High-performance C++ numeric library"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.oonumerics.org/blitz"
DEPEND="doc? ( virtual/tetex )
	icc? ( dev-lang/icc )"
RDEPEND=""
IUSE="icc doc"

SLOT="0"
KEYWORDS="~amd64 ppc x86"
LICENSE="GPL-2"

FORTAN="g77"

src_compile() {
	local myconf
	# ICC: if we've got it, use it
	use icc && myconf="--with-cxx=icc" || myconf="--with-cxx=gcc"
	use doc && myconf="$myconf --enable-latex-docs"
	myconf="${myconf} --enable-shared"

	export CC=$(tc-getCC) CXX=$(tc-getCXX)
	econf ${myconf} || die "econf failed"
}

src_test() {
	make check-testsuite || die "selftest failed"
}

src_install () {
	dodir /usr/share/doc/${PF}
	emake DESTDIR=${D} docdir=/usr/share/doc/${PF} install || die
	dodoc ChangeLog ChangeLog.1 LICENSE README README.binutils \
	      TODO COPYING LEGAL AUTHORS NEWS
}
