# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/couchdb-python/couchdb-python-0.6.1.ebuild,v 1.6 2010/06/19 16:50:17 arfrever Exp $

EAPI="2"

inherit distutils

DESCRIPTION="Python library for working with CouchDB"
HOMEPAGE="http://code.google.com/p/couchdb-python/ http://pypi.python.org/pypi/CouchDB"
SRC_URI="http://pypi.python.org/packages/source/C/CouchDB/CouchDB-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

RDEPEND="dev-python/httplib2
	|| ( >=dev-lang/python-2.6
		( dev-lang/python:2.5 dev-python/simplejson )
		( dev-lang/python:2.4 dev-python/simplejson ) )
	doc? ( dev-python/epydoc )"
DEPEND="dev-python/setuptools"

PYTHON_MODNAME="couchdb"
S="${WORKDIR}/CouchDB-${PV}"

src_install() {
	distutils_src_install

	if use doc; then
		epydoc --config=doc/conf/epydoc.ini
	fi

	dohtml -r doc/* || die "dohtml failed"
}

src_test() {
	python setup.py test
}
