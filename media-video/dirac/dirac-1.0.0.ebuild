# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/dirac/dirac-1.0.0.ebuild,v 1.4 2008/10/20 19:17:10 gmsoft Exp $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit eutils autotools

DESCRIPTION="Open Source video codec"
HOMEPAGE="http://dirac.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
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

	AT_M4DIR="m4" eautoreconf
}

src_compile() {
	econf \
		$(use_enable mmx) \
		$(use_enable debug) \
		$(use_enable doc) \
		|| die "econf failed"

	VARTEXFONTS="${T}/fonts" emake || die "emake failed"
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
