# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/vamos/vamos-0.5.5.ebuild,v 1.3 2009/02/12 20:38:59 tupone Exp $

EAPI=2
inherit eutils

DESCRIPTION="an automotive simulation framework"
HOMEPAGE="http://vamos.sourceforge.net/"
SRC_URI="mirror://sourceforge/vamos/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND="media-libs/libpng
	virtual/opengl
	virtual/glu
	virtual/glut
	=dev-libs/libsigc++-1.2*"

DEPEND="${RDEPEND}
	media-libs/plib"

src_prepare() {
	epatch "${FILESDIR}"/${P}-as-needed.patch
}

src_install() {
	make DESTDIR="${D}" install || die "make install"
	dobin caelum/.libs/caelum || die "caelum"
	newdoc caelum/README README.caelum
	dodoc AUTHORS ChangeLog NEWS README TODO
}
