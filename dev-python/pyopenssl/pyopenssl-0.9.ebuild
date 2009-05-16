# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyopenssl/pyopenssl-0.9.ebuild,v 1.1 2009/05/16 23:26:08 arfrever Exp $

inherit distutils eutils

MY_P=${P/openssl/OpenSSL}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Python interface to the OpenSSL library"
HOMEPAGE="http://pyopenssl.sourceforge.net/"
SRC_URI="mirror://sourceforge/pyopenssl/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc"

RDEPEND=">=dev-libs/openssl-0.9.6g"
DEPEND="${RDEPEND}
	doc? ( >=dev-tex/latex2html-2002.2 )"

src_compile() {
	distutils_src_compile
	if use doc; then
		addwrite /var/cache/fonts
		# This one seems to be unnecessary with a recent tetex, but
		# according to bugs it was definitely necessary in the past,
		# so leaving it in.
		addwrite /usr/share/texmf/fonts/pk

		cd "${S}"/doc
		make html ps dvi
	fi
}

src_install() {
	distutils_src_install

	if use doc; then
		dohtml "${S}"/doc/html/*
		dodoc "${S}"/doc/pyOpenSSL.*
	fi

	# Install examples
	docinto examples
	dodoc "${S}"/examples/*
	docinto examples/simple
	dodoc "${S}"/examples/simple/*
}

src_test() {
	cd test
	PYTHONPATH="$(ls -d ../build/lib.*)" "${python}" test_crypto.py || die "tests failed"
	PYTHONPATH="$(ls -d ../build/lib.*)" "${python}" test_ssl.py || die "tests failed"
}
