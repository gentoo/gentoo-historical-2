# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/zsi/zsi-2.0.ebuild,v 1.4 2008/03/13 13:19:52 angelos Exp $

inherit distutils

MY_PN="ZSI"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Web Services for Python"
HOMEPAGE="http://pywebsvcs.sourceforge.net/zsi.html"
SRC_URI="mirror://sourceforge/pywebsvcs/${MY_P}.tar.gz"

KEYWORDS="amd64 ~ppc64 ~x86"
SLOT="0"
LICENSE="PYTHON"
IUSE="examples doc twisted"

DEPEND=">=dev-python/pyxml-0.8.3
		>=dev-python/setuptools-0.6_rc3
		twisted? (
			>=dev-python/twisted-2.0
			>=dev-python/twisted-web-0.5.0
			>=dev-lang/python-2.4 )"

S="${WORKDIR}/${MY_P}"
PYTHON_MODNAME=${MY_PN}

src_unpack() {
	unpack ${A}
	cd "${S}"

	if ! use twisted ; then
		sed -i \
			-e "/version_info/d"\
			-e "/ZSI.twisted/d"\
			setup.py
	fi
}

src_install() {
	distutils_src_install

	if use doc ; then
		dohtml doc/*.html doc/*.css doc/*.png
	fi

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins -r doc/examples/* samples/*
	fi
}

DOCS="CHANGES README"
