# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/wesnoth/wesnoth-1.0.1.ebuild,v 1.3 2005/11/14 07:42:23 mr_bones_ Exp $

inherit eutils toolchain-funcs flag-o-matic games

MY_PV=${PV/_/}
DESCRIPTION="A fantasy turn-based strategy game"
HOMEPAGE="http://www.wesnoth.org/"
SRC_URI="mirror://sourceforge/wesnoth/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc x86"
IUSE="dedicated editor gnome kde lite nls server tools"

DEPEND=">=media-libs/libsdl-1.2.7
	!dedicated? (virtual/x11
	>=media-libs/freetype-2 )
	>=media-libs/sdl-mixer-1.2
	>=media-libs/sdl-image-1.2
	media-libs/sdl-net
	sys-libs/zlib"

S=${WORKDIR}/${PN}-${MY_PV}

src_unpack() {
	unpack ${A}
	if use server ; then
		sed \
			-e "s:GAMES_BINDIR:${GAMES_BINDIR}:" \
			-e "s:GAMES_STATEDIR:${GAMES_STATEDIR}:" \
			-e "s/GAMES_USER_DED/${GAMES_USER_DED}/" \
			-e "s/GAMES_GROUP/${GAMES_GROUP}/" "${FILESDIR}"/wesnothd.rc \
			> "${T}"/wesnothd \
			|| die "sed failed"
	fi

}
src_compile() {
	filter-flags -ftracer -fomit-frame-pointer
	if [[ $(gcc-major-version) -eq 3 ]] ; then
		filter-flags -fstack-protector
		append-flags -fno-stack-protector
	fi
	egamesconf \
		--disable-dependency-tracking \
		$(use_enable lite) \
		$(use_enable server) \
		$(use_enable server campaign-server) \
		$(use server && echo --with-server-uid=${GAMES_USER_DED} --with-server-gid=${GAMES_GROUP}) \
		$(use_enable editor) \
		$(use_enable tools) \
		$(use_enable nls) \
		$(use_enable !dedicated game) \
		$(use_with gnome) \
		$(use_with kde) \
		|| die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	mv "${D}${GAMES_DATADIR}/"{icons,applnk,applications} "${D}/usr/share/"
	dodoc MANUAL changelog
	if use server; then
		keepdir "${GAMES_STATEDIR}/run/wesnothd"
		doinitd "${T}"/wesnothd || die "doinitd failed"
	fi
	prepgamesdirs
}
