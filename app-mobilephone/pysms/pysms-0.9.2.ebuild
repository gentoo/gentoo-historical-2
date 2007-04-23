# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-mobilephone/pysms/pysms-0.9.2.ebuild,v 1.2 2007/04/23 19:36:37 swegener Exp $

inherit distutils

DESCRIPTION="Tool for sending text messages for various Swiss providers"
HOMEPAGE="http://people.ee.ethz.ch/~maandrea/pySms"
SRC_URI="http://people.ee.ethz.ch/~maandrea/pySms/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/pygtk"

RESTRICT="test"

src_install() {
	distutils_src_install
	dodoc AUTHORS PKG-INFO README
}
