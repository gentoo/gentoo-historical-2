# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/libpst/libpst-0.6.41.ebuild,v 1.4 2009/10/27 10:24:27 volkmar Exp $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="Tools and library for reading Outlook files (.pst format)"
HOMEPAGE="http://www.five-ten-sg.com/libpst/"
SRC_URI="http://www.five-ten-sg.com/${PN}/packages/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug dii python"

RDEPEND="dii? ( media-gfx/imagemagick[png] )"
DEPEND="virtual/libiconv
	dii? ( media-libs/gd[png] )
	python? ( >=dev-libs/boost-1.35.0-r5[python] )
	${RDEPEND}"

src_configure() {
	econf \
		$(use_enable debug pst-debug) \
		$(use_enable dii) \
		$(use_enable python) \
		--enable-libpst-shared
}

src_compile() {
	emake CC=$(tc-getCC) || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS TODO || die "dodoc failed"
}
