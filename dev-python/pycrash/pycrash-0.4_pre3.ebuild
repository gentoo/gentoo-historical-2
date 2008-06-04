# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pycrash/pycrash-0.4_pre3.ebuild,v 1.11 2008/06/04 11:47:53 jer Exp $

NEED_PYTHON=2.3

inherit distutils

MY_P="PyCrash-${PV/_/-}"
DESCRIPTION="PyCrash: a Run-Time Exception Dumper for Python programs"
HOMEPAGE="http://pycrash.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""
KEYWORDS="amd64 ~hppa ~ia64 ~ppc ~sparc x86 ~x86-fbsd"
DOCS="NEWS TODO THANKS"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	sed -i -e 's/pre2/pre3/' "${S}/pycrash/pycrash.py"
}
