# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyx/pyx-0.10-r1.ebuild,v 1.1 2008/09/03 10:58:40 bicatali Exp $

inherit distutils eutils

MY_P=${P/pyx/PyX}
DESCRIPTION="Python package for the generation of encapsulated PostScript figures"
HOMEPAGE="http://pyx.sourceforge.net/"
SRC_URI="mirror://sourceforge/pyx/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86"
IUSE="doc"

DEPEND="virtual/python
	virtual/tex-base
	doc? ( virtual/latex-base )"
RDEPEND="virtual/python
	virtual/tex-base"

S=${WORKDIR}/${MY_P}

DOCS="AUTHORS CHANGES INSTALL"

src_unpack() {
	distutils_src_unpack

	epatch "${FILESDIR}"/${P}.patch
	sed -i \
		-e 's/^build_t1code=.*/build_t1code=1/' \
		-e 's/^build_pykpathsea=.*/build_pykpathsea=1/' \
		setup.cfg || die "setup.cfg fix failed"

	sed -i -e 's/^texipc =.*/texipc = 1/' pyxrc || die
}

src_compile() {
	distutils_src_compile

	if use doc; then
		cd "${S}/faq"
		VARTEXFONTS="${T}"/fonts make pdf
	fi
}

src_install() {
	distutils_src_install

	if use doc; then
		# The manual is not currently done because it needs mkhowto
		# that's not currently available on our python ebuild
		insinto /usr/share/doc/${P}/
		doins faq/pyxfaq.pdf
	fi
}
