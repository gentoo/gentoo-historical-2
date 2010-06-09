# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/suds/suds-0.3.9.ebuild,v 1.3 2010/06/09 21:42:30 patrick Exp $

EAPI=3
PYTHON_DEPEND="2"

inherit distutils

MY_P="python-${P}"

DESCRIPTION="A lightweight SOAP python client"
HOMEPAGE="https://fedorahosted.org/suds/"
SRC_URI="https://fedorahosted.org/releases/s/u/suds/${MY_P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="dev-python/setuptools
	doc? ( dev-python/epydoc )"
RDEPEND=""

S=${WORKDIR}/${MY_P}

src_compile() {
	distutils_src_compile

	if use doc; then
		epydoc -n "Suds - ${DESCRIPTION}" -o "${S}"/doc \
			"${S}"/suds || die "epydoc failed"
	fi
}

src_install() {
	distutils_src_install

	use doc && dohtml -r doc/*
}
