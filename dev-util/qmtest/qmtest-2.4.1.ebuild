# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/qmtest/qmtest-2.4.1.ebuild,v 1.3 2009/07/31 08:06:01 fauli Exp $

inherit distutils

DESCRIPTION="CodeSourcery's test harness system"
HOMEPAGE="http://www.codesourcery.com/qmtest/"
SRC_URI="http://www.codesourcery.com/public/${PN}/${PF}/${PF}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips x86"
IUSE=""

DEPEND="dev-lang/python"

src_install() {
	distutils_src_install
	find "${D}" -name config.py -print0 | xargs -0 sed -i "s:${D}:/usr:"
}
