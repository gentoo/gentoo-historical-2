# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyogg/pyogg-1.3.ebuild,v 1.8 2007/07/11 06:19:47 mr_bones_ Exp $

inherit distutils

DESCRIPTION="Python bindings for the ogg library"
HOMEPAGE="http://www.andrewchatham.com/pyogg/"
SRC_URI="http://www.andrewchatham.com/pyogg/download/${P}.tar.gz"

IUSE=""
LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc sparc hppa ~amd64"

DEPEND="dev-lang/python
	>=media-libs/libogg-1.0"

src_compile() {
	./config_unix.py || die
	distutils_src_compile
}

DOCS="AUTHORS COPYING ChangeLog NEWS README"
