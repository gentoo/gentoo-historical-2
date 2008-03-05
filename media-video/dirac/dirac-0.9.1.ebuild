# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/dirac/dirac-0.9.1.ebuild,v 1.3 2008/03/05 23:20:17 aballier Exp $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit eutils autotools

DESCRIPTION="Open Source video codec"
HOMEPAGE="http://dirac.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mmx debug doc"

DEPEND="doc? ( app-doc/doxygen
	virtual/latex-base
	media-gfx/graphviz
	|| ( app-text/dvipdfm
		>=app-text/tetex-2
		app-text/ptex )
		)"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${PN}-0.5.2-doc.patch"

	eautoreconf
}

src_compile() {
	econf \
		$(use_enable mmx) \
		$(use_enable debug) \
		$(use_enable doc) \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" \
		htmldir="/usr/share/doc/${PF}/html" \
		latexdir="/usr/share/doc/${PF}/programmers" \
		algodir="/usr/share/doc/${PF}/algorithm" \
		faqdir="/usr/share/doc/${PF}" \
		install || die "emake install failed"

	dodoc README AUTHORS NEWS TODO ChangeLog
}
