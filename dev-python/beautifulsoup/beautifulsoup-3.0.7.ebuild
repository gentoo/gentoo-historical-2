# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/beautifulsoup/beautifulsoup-3.0.7.ebuild,v 1.1 2008/06/25 09:46:05 hawking Exp $

NEED_PYTHON="2.3"

inherit distutils

MY_PN=BeautifulSoup
MY_P=${MY_PN}-${PV}

DESCRIPTION="HTML/XML parser for quick-turnaround applications like screen-scraping."
HOMEPAGE="http://www.crummy.com/software/BeautifulSoup/"
SRC_URI="http://www.crummy.com/software/${MY_PN}/download/${MY_P}.tar.gz"
LICENSE="PSF-2.3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

S=${WORKDIR}/${MY_P}

src_test() {
	PYTHONPATH="." "${python}" BeautifulSoupTests.py || die "tests failed"
}
