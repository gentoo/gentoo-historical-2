# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/neoengine/neoengine-0.8.2.ebuild,v 1.1 2006/03/03 18:56:54 tupone Exp $

inherit eutils autotools

DESCRIPTION="An open source, platform independent, 3D game engine written in C++"
HOMEPAGE="http://www.neoengine.org/"
SRC_URI="mirror://sourceforge/neoengine/${P}.tar.bz2"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE="doc"

DEPEND="virtual/opengl
	media-libs/alsa-lib
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/neoengine"

src_unpack() {

	unpack "${A}"
	cd "${S}"

	./setbuildtype.sh dynamic

	eautoreconf || "eautoreconf failed"
	eautomake neodevopengl/Makefile || "eautomake neodevopengl failed"
	eautomake neodevalsa/Makefile || "eautomake neodevalsa failed"
}

src_compile() {
	econf \
		--disable-dependency-tracking \
		|| die "econf failed"
	emake || die "emake failed"

	if use doc; then
		emake doc || die "emake doc failed"
	fi
}

src_install() {
	einstall || die "Installation failed"

	dodoc AUTHORS ChangeLog* NEWS README

	use doc && dohtml -r *-api
}
