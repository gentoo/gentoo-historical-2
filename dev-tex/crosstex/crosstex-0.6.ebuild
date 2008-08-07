# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/crosstex/crosstex-0.6.ebuild,v 1.1 2008/08/07 22:41:27 aballier Exp $

inherit python

DESCRIPTION="CrossTeX - object oriented BibTeX replacement"
HOMEPAGE="http://www.cs.cornell.edu/people/egs/crosstex/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="dev-lang/python
	dev-python/ply"
DEPEND="${RDEPEND}"

src_install() {
	python_version

	cd "${S}"
	emake \
		ROOT="${D}" \
		PREFIX="/usr" \
		LIBDIR="/$(get_libdir)/python${PYVER}/site-packages" \
		install || die "make install failed"

	insinto /usr/share/doc/${PF}
	doins "${PN}".pdf
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins tests/*
	fi
}

pkg_postinst() {
	python_version
	python_mod_optimize	/usr/$(get_libdir)/python${PYVER}/site-packages/${PN}
}

pkg_postrm() {
	python_mod_cleanup
}
