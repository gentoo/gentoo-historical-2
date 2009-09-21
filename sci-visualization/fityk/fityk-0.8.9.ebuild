# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/fityk/fityk-0.8.9.ebuild,v 1.1 2009/09/21 05:30:15 bicatali Exp $

EAPI=2
WX_GTK_VER="2.8"

inherit eutils wxwidgets

DESCRIPTION="General-purpose nonlinear curve fitting and data analysis"
HOMEPAGE="http://www.unipress.waw.pl/fityk/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples gnuplot python readline wxwidgets"

CDEPEND=">=sci-libs/xylib-0.4
	python? ( dev-lang/python )
	readline? ( sys-libs/readline )
	wxwidgets? ( x11-libs/wxGTK:2.8 )"

DEPEND="${CDEPEND}
	>=sys-devel/libtool-2.2"

RDEPEND="${CDEPEND}
	gnuplot? ( sci-visualization/gnuplot )"

src_prepare() {
	has_version "<dev-libs/boost-1.37" && \
		sed -i -e 's:impl/directives.hpp:directives.ipp:g' \
		"${S}/src/optional_suffix.h"
}

src_configure() {
	econf  \
		--docdir="/usr/share/doc/${PF}" \
		--disable-3rdparty \
		--without-xylib \
		$(use_enable python) \
		$(use_enable wxwidgets GUI) \
		$(use_with doc) \
		$(use_with examples samples) \
		$(use_with readline)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc NEWS README TODO
}
