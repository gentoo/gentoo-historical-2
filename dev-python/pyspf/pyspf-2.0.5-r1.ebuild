# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyspf/pyspf-2.0.5-r1.ebuild,v 1.2 2010/07/19 00:26:35 dragonheart Exp $

EAPI="2"
PYTHON_DEPEND="2"
# needs python3 compatible net-dns/pydns version to work with version 3
inherit distutils eutils

DESCRIPTION="Python implementation of the Sender Policy Framework (SPF) protocol"
SRC_URI="mirror://sourceforge/pymilter/${P}.tar.gz
		mirror://gentoo/${P}-2to3.patch.gz"
HOMEPAGE="http://cheeseshop.python.org/pypi/pyspf"

IUSE=""
SLOT="0"
LICENSE="PSF-2.4"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/pydns"
RDEPEND="dev-python/pydns"

src_prepare() {
	epatch "${DISTDIR}"/${P}-2to3.patch.gz \
			"${FILESDIR}"/2.0.5-deprecated.patch
	distutils_src_prepare
}
