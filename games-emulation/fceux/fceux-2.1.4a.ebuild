# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/fceux/fceux-2.1.4a.ebuild,v 1.5 2010/11/20 10:51:02 mr_bones_ Exp $

EAPI=2
inherit scons-utils games

DESCRIPTION="A portable Famicom/NES emulator, an evolution of the original FCE Ultra"
HOMEPAGE="http://fceux.com/"
SRC_URI="mirror://sourceforge/fceultra/${P}.src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+lua +opengl"

RDEPEND="lua? ( dev-lang/lua )
	media-libs/libsdl[opengl?,video]
	opengl? ( virtual/opengl )
	x11-libs/gtk+:2
	sys-libs/zlib
	gnome-extra/zenity"
# Note: zenity is "almost" optional. It is possible to compile and run fceux
# without zenity, but file dialogs will not work.

S=${WORKDIR}/fceu${PV}

src_prepare() {
	# mentioned in bug #335836
	if ! use lua ; then
		sed -i -e '/_S9XLUA_H/d' SConstruct || die
	fi
}

src_compile() {
	escons \
		CREATE_AVI=1 \
		$(use_scons opengl OPENGL) \
		$(use_scons lua LUA) \
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
