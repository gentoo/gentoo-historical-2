# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/dirac/dirac-0.5.2.ebuild,v 1.1 2005/06/10 01:45:50 flameeyes Exp $

inherit eutils

DESCRIPTION="Open Source video codec"
HOMEPAGE="http://dirac.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="mmx debug doc"

DEPEND="doc? ( app-doc/doxygen
	virtual/tetex )"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${P}-doc.patch

	autoreconf || die "autoreconf failed"
	libtoolize --copy --force || die "libtoolize failed"
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
	make DESTDIR="${D}" \
		htmldir="/usr/share/doc/${PF}/html" \
		latexdir="/usr/share/doc/${PF}/programmers" \
		algodir="/usr/share/doc/${PF}/algorithm" \
		faqdir="/usr/share/doc/${PF}" \
		install

	dodoc README AUTHORS NEWS TODO ChangeLog
}
