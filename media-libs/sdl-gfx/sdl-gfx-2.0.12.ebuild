# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/sdl-gfx/sdl-gfx-2.0.12.ebuild,v 1.4 2004/10/12 01:39:32 vapier Exp $

inherit flag-o-matic

MY_P="${P/sdl-/SDL_}"
DESCRIPTION="Graphics drawing primitives library for SDL"
HOMEPAGE="http://www.ferzkopp.net/~aschiffler/Software/SDL_gfx-2.0/index.html"
SRC_URI="http://www.ferzkopp.net/~aschiffler/Software/SDL_gfx-2.0/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc sparc x86"
IUSE="mmx"

DEPEND=">=media-libs/libsdl-1.2"

S="${WORKDIR}/${MY_P}"

src_compile() {
	filter-flags -finline-functions #26892
	replace-flags -O? -O2

	local myconf
	if use ppc || use sparc || use alpha || use amd64
	then
		myconf="--disable-mmx"
	else
		use mmx || myconf="--disable-mmx"
	fi

	econf ${myconf} || die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog README
	dohtml -r Docs/*
}
