# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-mhash/python-mhash-1.3.ebuild,v 1.1 2005/02/18 21:07:45 robbat2 Exp $

inherit distutils

DESCRIPTION="Python interface to libmhash"
SRC_URI="mirror://sourceforge/mhash/${P}.tar.gz"
HOMEPAGE="http://mhash.sourceforge.net/"
RDEPEND="virtual/python
		app-crypt/mhash"
DEPEND="${RDEPEND}
		sys-apps/sed"
IUSE=""
SLOT="0"
KEYWORDS="x86"
LICENSE="GPL-2"

src_unpack() {
	unpack ${A}
	# fix a glitch for gcc3.3 compiling
	sed '231s/$/\\/' -i ${S}/mhash.c
	# fix typo in MHASH_WHIRLPOOL definition
	sed -i -e 's/MHSH_WHIRLPOOL/MHASH_WHIRLPOOL/' ${S}/mhash.c
	# fix typo in package setup.py definition
	sed -i -e 's/VERSION = "1.2"/VERSION = "1.3"/' ${S}/setup.py
}

src_install() {
	mydoc="AUTHORS LICENSE NEWS PKG-INFO README"
	distutils_src_install
}
