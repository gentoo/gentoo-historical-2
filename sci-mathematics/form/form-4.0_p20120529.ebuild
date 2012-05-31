# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/form/form-4.0_p20120529.ebuild,v 1.1 2012/05/31 12:25:24 grozin Exp $

EAPI=4

inherit autotools

DESCRIPTION="Symbolic Manipulation System"
HOMEPAGE="http://www.nikhef.nl/~form/"
SRC_URI="http://github.com/downloads/jauhien/sources/${P}.tar.gz"

S="${WORKDIR}/formcvs"

LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~x86"
IUSE="devref doc doxygen gmp mpi threads zlib"

DEPEND="devref? ( dev-texlive/texlive-latex )
	doc? ( dev-texlive/texlive-latex )
	doxygen? ( app-doc/doxygen )
	gmp? ( dev-libs/gmp )
	mpi? ( virtual/mpi )
	zlib? ( sys-libs/zlib )
"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i 's/LINKFLAGS = -s/LINKFLAGS =/' sources/Makefile.am || die
	eautoreconf
}

src_configure() {
	econf \
		--enable-scalar \
		--enable-largefile \
		--disable-debug \
		--disable-static-link \
		--with-api=posix \
		$(use_with gmp ) \
		$(use_enable mpi parform ) \
		$(use_enable threads threaded ) \
		$(use_with zlib ) \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CXXFLAGS="${CXXFLAGS}"
}

src_compile() {
	default
	if use devref; then
		pushd doc/devref > /dev/null
		LANG=C emake pdf
		popd > /dev/null
	fi
	if use doc; then
		pushd doc/manual > /dev/null
		LANG=C emake pdf
		popd > /dev/null
	fi
	if use doxygen; then
		pushd doc/doxygen > /dev/null
		emake html
		popd > /dev/null
	fi
}

src_install() {
	default
	if use devref; then
		insinto /usr/share/doc/${PF}
		doins doc/devref/devref.pdf
	fi
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins doc/manual/manual.pdf
	fi
	if use doxygen; then
		dohtml -r doc/doxygen/html/*
	fi
}
