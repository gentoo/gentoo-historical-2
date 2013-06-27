# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/google-api-python-client/google-api-python-client-1.1.ebuild,v 1.1 2013/06/27 03:12:32 robbat2 Exp $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} pypy{1_9,2_0} )

inherit distutils-r1

DESCRIPTION="Google API Client for Python"
HOMEPAGE="http://code.google.com/p/google-api-python-client/"
SRC_URI="https://google-api-python-client.googlecode.com/files/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/python-gflags
		>=dev-python/httplib2-0.8
		dev-python/simplejson
		dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"


