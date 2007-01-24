# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/allegrogl/allegrogl-0.4.0.ebuild,v 1.1 2007/01/24 21:57:18 tupone Exp $

inherit eutils

MY_PN="alleggl"

DESCRIPTION="A library to mix OpenGL graphics with Allegro routines"
HOMEPAGE="http://allegrogl.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}-${PV}.tar.bz2"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND=">=media-libs/allegro-4.2.0
	virtual/opengl
	virtual/glu"

S=${WORKDIR}/${MY_PN}

src_compile() {
	econf || die "econf failed"
	emake -j1 || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc changelog {bugs,extensions,faq,howto,quickstart,readme,todo}.txt
	dohtml -r docs/html/*
	if use examples ; then
		insinto /usr/share/${PN}/examples
		doins examp/*.{bmp,c,dat,h,pcx,tga} || die "doins failed"
	fi
}
