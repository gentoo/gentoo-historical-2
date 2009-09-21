# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/geos/geos-3.1.1.ebuild,v 1.2 2009/09/21 21:41:40 maekke Exp $

EAPI=2

DESCRIPTION="Geometry engine library for Geographic Information Systems"
HOMEPAGE="http://geos.refractions.net"
SRC_URI="http://download.osgeo.org/geos/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~sparc x86"
IUSE="doc python ruby"

RDEPEND="ruby? ( virtual/ruby )
	python? ( virtual/python )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	ruby?  ( dev-lang/swig )
	python? ( dev-lang/swig )"

src_configure() {
	econf $(use_enable python) $(use_enable ruby)
}

src_compile() {
	emake || die "emake failed"
	if use doc; then
		cd "${S}/doc"
		emake doxygen-html || die "doc generation failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS NEWS README TODO
	if use doc; then
		cd "${S}/doc"
		dohtml -r doxygen_docs/html/* || die
	fi
}
