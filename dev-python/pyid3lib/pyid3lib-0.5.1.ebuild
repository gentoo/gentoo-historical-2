# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyid3lib/pyid3lib-0.5.1.ebuild,v 1.8 2004/08/30 15:32:50 pvdabeel Exp $

inherit distutils

DESCRIPTION="Module for manipulating ID3 tags in Python"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
HOMEPAGE="http://pyid3lib.sourceforge.net/"
IUSE=""
SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="x86 ppc amd64 ~sparc"
DEPEND="virtual/python
	media-libs/id3lib"

src_install() {
	distutils_src_install
	dohtml doc.html
}

