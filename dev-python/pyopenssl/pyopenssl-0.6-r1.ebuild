# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyopenssl/pyopenssl-0.6-r1.ebuild,v 1.1 2006/07/01 11:26:30 marienz Exp $

inherit distutils

MY_P=${P/openssl/OpenSSL}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Python interface to the OpenSSL library"
HOMEPAGE="http://pyopenssl.sourceforge.net/"
SRC_URI="mirror://sourceforge/pyopenssl/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="doc"

RDEPEND="dev-lang/python
	>=dev-libs/openssl-0.9.6g"
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

	# install examples
	docinto examples
	dodoc "${S}"/examples/*
	docinto examples/simple
	dodoc "${S}"/examples/simple/*
}
