# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-sports/gracer/gracer-0.1.5.ebuild,v 1.17 2008/01/19 00:43:31 mr_bones_ Exp $

inherit eutils games

DESCRIPTION="3D motor sports simulator"
HOMEPAGE="http://gracer.sourceforge.net/"
SRC_URI="mirror://sourceforge/gracer/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="joystick"

DEPEND="x11-libs/libXi
	x11-libs/libXmu
	virtual/glu
	virtual/glut
	virtual/opengl
	dev-lang/tcl
	media-libs/giflib
	media-libs/jpeg
	media-libs/libpng
	media-libs/plib"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PV}-gldefs.patch \
		"${FILESDIR}"/${PN}-gcc-3.4.patch \
		"${FILESDIR}/${P}"-gcc41.patch
}

src_compile() {
	egamesconf \
		--enable-gif \
		--enable-jpeg \
		--enable-png \
		$(use_enable joystick) \
		|| die
	sed -i \
		-e 's:-lplibsl:-lplibsl -lplibul:' $(find -name Makefile) \
			|| die "sed Makefiles failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README
	prepgamesdirs
}
