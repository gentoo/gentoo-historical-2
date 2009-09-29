# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/fceux/fceux-2.1.1.ebuild,v 1.2 2009/09/29 04:55:01 mr_bones_ Exp $

EAPI=2
inherit games

DESCRIPTION="A portable Famicom/NES emulator, an evolution of the original FCE Ultra"
HOMEPAGE="http://fceux.com/"
SRC_URI="mirror://sourceforge/fceultra/${P}.src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+lua +opengl"

RDEPEND="lua? ( dev-lang/lua )
	media-libs/libsdl[opengl?,video]
	opengl? ( virtual/opengl )
	sys-libs/zlib"
DEPEND="${RDEPEND}
	dev-util/scons"
RDEPEND="${RDEPEND}
	gnome-extra/zenity"
# Note: zenity is "almost" optional. It is possible to compile and run fceux
# without zenity, but file dialogs will not work.

S=${WORKDIR}/fceu

src_compile() {
	local sconsopts=$(echo "${MAKEOPTS}" | sed -ne "/-j/ { s/.*\(-j[[:space:]]*[0-9]\+\).*/\1/; p }")
	scons \
		${sconsopts} \
		CREATE_AVI=1 \
		OPENGL=$(use opengl && echo 1 || echo 0) \
		LUA=$(use lua && echo 1 || echo 0) \
		|| die "scons failed"
}

src_install() {
	dogamesbin bin/fceux || die

	doman documentation/fceux.6 || die
	dodoc Authors.txt changelog.txt TODO-PROJECT

	# Extra documentation
	insinto "/usr/share/doc/${PF}/"
	doins -r bin/fceux.chm documentation
	rm -f "${D}/usr/share/doc/${PF}/documentation/fceux.6"

	prepgamesdirs
}
