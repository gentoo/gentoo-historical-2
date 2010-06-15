# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-poppler/python-poppler-0.12.1.ebuild,v 1.7 2010/06/15 13:59:24 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2:2.6"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 2.5 3.*"
PYTHON_EXPORT_PHASE_FUNCTIONS="1"

inherit libtool python

DESCRIPTION="Python bindings to the Poppler PDF library"
HOMEPAGE="http://launchpad.net/poppler-python"
SRC_URI="http://launchpad.net/poppler-python/trunk/development/+download/pypoppler-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples"

S="${WORKDIR}/pypoppler-${PV}"

RDEPEND=">=app-text/poppler-0.12.3-r3[cairo]
	>=dev-python/pycairo-1.8.4
	dev-python/pygobject:2
	dev-python/pygtk:2"
DEPEND="${RDEPEND}"

src_prepare() {
	elibtoolize
	python_copy_sources
}

src_install() {
	python_src_install
	python_clean_installation_image

	dodoc NEWS || die "dodoc failed"

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins demo/demo-poppler.py || die "doins failed"
	fi
}
