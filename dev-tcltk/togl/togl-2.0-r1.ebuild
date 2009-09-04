# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/togl/togl-2.0-r1.ebuild,v 1.1 2009/09/04 06:23:33 mescalinum Exp $

EAPI="2"

MY_P="Togl${PV}"

DESCRIPTION="A Tk widget for OpenGL rendering"
HOMEPAGE="http://togl.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}-src.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +threads"

RDEPEND="dev-lang/tk
	virtual/opengl"
DEPEND="${RDEPEND}"

# tests directory is missing
RESTRICT="test"

S="${WORKDIR}"/${MY_P}

src_configure() {
	econf \
		$(use_enable debug symbols) \
		$(use_enable amd64 64bit) \
		$(use_enable threads)
}

src_install() {
	emake DESTDIR="${D}" install || die "failed to install"
	dohtml doc/* || die "no html"
	dodoc README* || die "no README"
}
