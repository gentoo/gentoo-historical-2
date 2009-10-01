# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/markdown/markdown-2.0.1.ebuild,v 1.2 2009/10/01 20:12:29 klausman Exp $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

MY_PN="Markdown"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Python implementation of the markdown markup language"
HOMEPAGE="http://www.freewisdom.org/projects/python-markdown"
SRC_URI="http://pypi.python.org/packages/source/M/${MY_PN}/${MY_P}.tar.gz"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~x86"
IUSE="pygments"

RDEPEND="pygments? ( dev-python/pygments )"

RESTRICT_PYTHON_ABIS="3*"

S=${WORKDIR}/${MY_P}

src_install() {
	distutils_src_install
	dodoc docs/*
	docinto extensions
	dodoc docs/extensions/*
}
