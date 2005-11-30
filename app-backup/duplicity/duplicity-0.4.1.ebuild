# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/duplicity/duplicity-0.4.1.ebuild,v 1.1 2005/07/04 05:22:39 robbat2 Exp $

IUSE=""
DESCRIPTION="duplicity is a secure backup system using gnupg to encrypt data"
HOMEPAGE="http://www.nongnu.org/duplicity/"
SRC_URI="http://savannah.nongnu.org/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"

DEPEND="virtual/libc
	>=dev-lang/python-2.3
	>=net-libs/librsync-0.9.6"
RDEPEND="${DEPEND}
	app-crypt/gnupg"

src_compile() {
	python setup.py build || die "compile failed"
}

src_install() {
	python setup.py install --prefix=${D}/usr
}
