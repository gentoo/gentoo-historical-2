# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/iniparse/iniparse-0.4.ebuild,v 1.1 2011/08/10 15:05:57 scarabeus Exp $

EAPI=3

SUPPORT_PYTHON_ABIS="1"
PYTHON_DEPEND="2:2.6"
RESTRICT_PYTHON_ABIS="2.[45] 3.*"

inherit distutils

DESCRIPTION="Better INI parser for Python"
HOMEPAGE="http://code.google.com/p/iniparse"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
