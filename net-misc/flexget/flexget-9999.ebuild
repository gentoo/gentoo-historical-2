# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/flexget/flexget-9999.ebuild,v 1.21 2012/08/16 03:28:22 floppym Exp $

EAPI=4

PYTHON_DEPEND="2:2.6"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 2.5 *-pypy-* 3.*"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils eutils

if [[ ${PV} != 9999 ]]; then
	MY_P="FlexGet-${PV/_beta/r}"
	SRC_URI="http://download.flexget.com/unstable/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
else
	inherit subversion
	SRC_URI=""
	ESVN_REPO_URI="http://svn.flexget.com/trunk"
	KEYWORDS=""
fi

DESCRIPTION="Multipurpose automation tool for content like torrents, nzbs, podcasts, comics"
HOMEPAGE="http://flexget.com/"

LICENSE="MIT"
SLOT="0"
IUSE="test"

DEPEND="
	>=dev-python/feedparser-5.1.2
	>=dev-python/sqlalchemy-0.7
	dev-python/pyyaml
	dev-python/beautifulsoup:python-2
	dev-python/beautifulsoup:4
	dev-python/html5lib
	dev-python/jinja
	dev-python/PyRSS2Gen
	dev-python/pynzb
	dev-python/progressbar
	dev-python/flask
	dev-python/cherrypy
	dev-python/python-dateutil
	>=dev-python/requests-0.10.0
	!=dev-python/requests-0.10.1
	|| ( dev-lang/python:2.7 dev-python/argparse )
	dev-python/setuptools
"
RDEPEND="${DEPEND}"
DEPEND+=" test? ( dev-python/nose )"

if [[ ${PV} == 9999 ]]; then
	DEPEND+=" dev-python/paver"
else
	S="${WORKDIR}/${MY_P}"
fi

src_prepare() {
	# Prevent setup from grabbing nose from pypi
	sed -e /setup_requires/d \
		-e '/SQLAlchemy/s/, <0.8//' \
		-e '/BeautifulSoup/s/, <3.3//' \
		-e '/beautifulsoup4/s/, <4.2//' \
		-e '/requests/s/, <0.11//' \
		-i pavement.py || die

	if [[ ${PV} == 9999 ]]; then
		# Generate setup.py
		paver generate_setup || die
	fi

	epatch_user
	distutils_src_prepare
}
