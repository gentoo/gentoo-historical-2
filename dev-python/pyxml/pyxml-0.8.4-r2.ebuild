# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyxml/pyxml-0.8.4-r2.ebuild,v 1.4 2009/07/15 13:02:11 fauli Exp $

inherit distutils

MY_P=${P/pyxml/PyXML}

DESCRIPTION="A collection of libraries to process XML with Python"
HOMEPAGE="http://pyxml.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="PYTHON"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"
IUSE="doc examples"

DEPEND=">=dev-libs/expat-1.95.6"

S=${WORKDIR}/${MY_P}

src_unpack(){
	distutils_src_unpack
	epatch "${FILESDIR}"/${P}-python-2.6.patch
}

src_compile() {
	local myconf

	# if you want to use 4Suite, then their XSLT/XPATH is
	# better according to the docs
	if has_version "dev-python/4suite"; then
		myconf="--without-xslt --without-xpath"
	fi

	# use the already-installed shared copy of libexpat
	distutils_src_compile --with-libexpat=/usr ${myconf}
}

src_install() {
	DOCS="ANNOUNCE CREDITS doc/*.txt"
	distutils_src_install

	doman doc/man/*
	if use doc; then
		dohtml -A api,web -r doc/*
		insinto /usr/share/doc/${PF} && doins doc/*.tex
	fi
	use examples && cp -r demo "${D}"/usr/share/doc/${PF}
}

pkg_postinst(){
	python_mod_optimize "$(python_get_sitedir)/_xmlplus"
}

src_test() {
	cd test
	PYTHONPATH="$(ls -d ../build/lib.*)" "${python}" regrtest.py \
		|| die "tests failed"
}
