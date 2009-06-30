# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/sdl-gfx/sdl-gfx-2.0.19.ebuild,v 1.3 2009/06/30 20:56:25 fauli Exp $

EAPI=2

MY_P="${P/sdl-/SDL_}"
DESCRIPTION="Graphics drawing primitives library for SDL"
HOMEPAGE="http://www.ferzkopp.net/joomla/content/view/19/14/"
SRC_URI="http://www.ferzkopp.net/Software/SDL_gfx-2.0/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha ~amd64 ~hppa ~ia64 ~ppc ~sparc x86 ~x86-fbsd"
IUSE="mmx"

DEPEND="media-libs/libsdl"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -i -e 's/-O//' configure || die "sed failed"
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		$(use_enable mmx) \
		|| die
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README
	dohtml -r Docs/*
}
