# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/chardet/chardet-1.0.ebuild,v 1.4 2010/01/09 20:52:46 armin76 Exp $

inherit distutils

DESCRIPTION="Character encoding auto-detection in Python."
HOMEPAGE="http://chardet.feedparser.org/"
SRC_URI="http://chardet.feedparser.org/download/${P}.tgz"
IUSE=""
DEPEND=""
RDEPEND=""
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm x86"

src_install() {
	distutils_src_install
	dohtml -r ${S}/docs/
}
