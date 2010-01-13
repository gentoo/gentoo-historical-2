# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/crypto++/crypto++-5.6.0-r1.ebuild,v 1.2 2010/01/13 19:30:53 ranger Exp $

EAPI="2"

inherit eutils flag-o-matic multilib toolchain-funcs

DESCRIPTION="Crypto++ is a C++ class library of cryptographic schemes"
HOMEPAGE="http://cryptopp.com"
SRC_URI="mirror://sourceforge/cryptopp/cryptopp${PV//.}.zip"

LICENSE="cryptopp"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ppc64 ~sparc ~x86"
DEPEND="app-arch/unzip"
RDEPEND=""
IUSE="sse3"

S="${WORKDIR}"

src_prepare() {
	epatch "${FILESDIR}/${P}-fix_build_system.patch"
}

src_compile() {
	# More than -O1 gives problems.
	replace-flags -O? -O1
	filter-flags -fomit-frame-pointer
	use sse3 || append-flags -DCRYPTOPP_DISABLE_SSE2
	emake -f GNUmakefile \
		LIBDIR="$(get_libdir)" \
		CXX="$(tc-getCXX)" CXXFLAGS="${CXXFLAGS}" || die "emake failed"
}

src_test() {
	# Make sure all test vectors have unix line endings.
	for file in TestVectors/*; do
		edos2unix ${file}
	done

	if ! emake CXX="$(tc-getCXX)" CXXFLAGS="${CXXFLAGS}" test; then
	    eerror "Crypto++ self-tests failed."
	    eerror "Try to remove some optimization flags and reemerge Crypto++."
	    die "emake test failed"
	fi;
}

src_install() {
	emake DESTDIR="${D}" LIBDIR="$(get_libdir)" install || die "emake install failed"
}
