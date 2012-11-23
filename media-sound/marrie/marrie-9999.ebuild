# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/marrie/marrie-9999.ebuild,v 1.1 2012/11/23 01:28:57 rafaelmartins Exp $

EAPI=4

PYTHON_DEPEND="2:2.7"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 2.5 2.6 3.*"

HG_ECLASS=""
if [[ ${PV} = *9999* ]]; then
	HG_ECLASS="mercurial"
	EHG_REPO_URI="http://hg.rafaelmartins.eng.br/marrie/"
	EHG_REVISION="default"
fi

inherit distutils ${HG_ECLASS}

DESCRIPTION="A simple podcast client that runs on the Command Line Interface"
HOMEPAGE="http://projects.rafaelmartins.eng.br/marrie/"

SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
if [[ ${PV} = *9999* ]]; then
	SRC_URI=""
	KEYWORDS=""
fi

LICENSE="BSD"
SLOT="0"
IUSE="doc"

RDEPEND="virtual/python-argparse
	dev-python/feedparser"
DEPEND="${RDEPEND}
	doc? ( dev-python/docutils )"

src_compile() {
	distutils_src_compile
	if use doc; then
		rst2html.py README.rst marrie.html || die "rst2html.py failed"
	fi
}

src_install() {
	distutils_src_install
	if use doc; then
		dohtml marrie.html
	fi
}
