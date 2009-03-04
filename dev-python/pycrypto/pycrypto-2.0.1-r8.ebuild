# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pycrypto/pycrypto-2.0.1-r8.ebuild,v 1.3 2009/03/04 16:49:58 ranger Exp $

NEED_PYTHON=2.5
inherit distutils toolchain-funcs flag-o-matic

DESCRIPTION="Python Cryptography Toolkit"
HOMEPAGE="http://www.amk.ca/python/code/crypto.html"
SRC_URI="http://www.amk.ca/files/python/crypto/${P}.tar.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ppc64 ~s390 ~sh sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE="bindist gmp test"

RDEPEND="virtual/python
	gmp? ( dev-libs/gmp )"
DEPEND="${RDEPEND}
	test? ( =dev-python/sancho-0.11-r1 )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	use bindist && epatch "${FILESDIR}"/${P}-bindist.patch
	epatch "${FILESDIR}"/${P}-sha256.patch
	epatch "${FILESDIR}"/${P}-sha256-2.patch
	epatch "${FILESDIR}"/${P}-gmp.patch
	epatch "${FILESDIR}"/${P}-uint32.patch
	epatch "${FILESDIR}"/${P}-sancho-package-rename.patch
	epatch "${FILESDIR}"/${P}-2.6_hashlib.patch
	#ARC2 buffer overlow. Bug 258049
	epatch "${FILESDIR}"/${P}-CVE-2009-0544.patch
}

src_compile() {
	use gmp \
		&& export USE_GMP=1 \
		|| export USE_GMP=0
	# sha256 hashes occasionally trigger ssp when built with
	# -finline-functions (implied by -O3).
	gcc-specs-ssp && append-flags -fno-inline-functions
	distutils_src_compile
	python_need_rebuild
}

src_test() {
	export PYTHONPATH=$(ls -d "${S}"/build/lib.*/)
	python ./test.py || die "test failed"
	if use test ; then
		local x
		cd test
		for x in test_*.py ; do
			python ${x} || die "${x} failed"
		done
	fi
}

DOCS="ACKS ChangeLog PKG-INFO README TODO Doc/pycrypt.tex"
