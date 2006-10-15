# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/paramiko/paramiko-1.6.ebuild,v 1.3 2006/10/15 17:52:36 kloeri Exp $

inherit distutils eutils

DESCRIPTION="SSH2 implementation for Python"
HOMEPAGE="http://www.lag.net/paramiko/"
SRC_URI="http://www.lag.net/paramiko/download/${P}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ia64 ~ppc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=dev-python/pycrypto-1.9_alpha6"
DEPEND="${RDEPEND}
	app-arch/unzip"


src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-no-setuptools.patch"
}

src_install() {
	distutils_src_install
	dohtml -r docs/*
	insinto /usr/share/doc/${PF}
	doins -r demos
}

src_test() {
	"${python}" test.py || die "tests failed"
}
