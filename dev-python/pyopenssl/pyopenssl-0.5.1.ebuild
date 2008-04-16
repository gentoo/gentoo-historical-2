# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyopenssl/pyopenssl-0.5.1.ebuild,v 1.5 2008/04/16 11:07:38 hawking Exp $

inherit distutils

MY_P=${P/openssl/OpenSSL}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Python interface to the OpenSSL library"
HOMEPAGE="http://pyopenssl.sourceforge.net/"
SRC_URI="mirror://sourceforge/pyopenssl/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 amd64 ~ppc alpha"
IUSE="doc"

RDEPEND="virtual/python
	>=dev-libs/openssl-0.9.6g"
DEPEND="${RDEPEND}
	doc? ( >=dev-tex/latex2html-2002.2 )"

src_compile() {
	distutils_src_compile
	if use doc ; then
		addwrite /var/cache/fonts
		cd "${S}"/doc
		make html ps dvi
	fi
}

src_install() {
	distutils_src_install

	if use doc ; then
		dohtml "${S}"/doc/html/*
		dodoc "${S}"/doc/pyOpenSSL.*
	fi

	# install examples
	docinto examples
	dodoc "${S}"/examples/*
	docinto examples/simple
	dodoc "${S}"/examples/simple/*
}
