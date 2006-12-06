# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/tremulous-bin/tremulous-bin-1.1.0.ebuild,v 1.3 2006/12/06 20:16:45 wolf31o2 Exp $

inherit eutils games

MY_PN=${PN%-bin}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Team-based aliens vs humans FPS with buildable structures"
HOMEPAGE="http://tremulous.net/"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.zip
	http://0day.icculus.org/mirrors/${MY_PN}/${MY_P}.zip
	ftp://ftp.wireplay.co.uk/pub/quake3arena/mods/${MY_PN}/${MY_P}.zip"

LICENSE="GPL-2
	CCPL-Attribution-ShareAlike-2.5"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated sdl"

UIDEPEND="virtual/opengl
	x86? (
		media-libs/alsa-lib
		media-libs/openal
		media-libs/libogg
		media-libs/libvorbis
		media-libs/libsdl
		x11-libs/libX11
		x11-libs/libXau
		x11-libs/libXdmcp
		x11-libs/libXext
		x11-libs/libXxf86dga
		x11-libs/libXxf86vm )
	amd64? (
		app-emulation/emul-linux-x86-sdl
		app-emulation/emul-linux-x86-medialibs )"
RDEPEND="sdl? ( ${UIDEPEND} )
	!sdl? ( !dedicated? ( ${UIDEPEND} ) )
	!games-fps/tremulous"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${MY_PN}
dir=${GAMES_PREFIX_OPT}/${MY_PN}

install_client() {
	if use sdl || ! use dedicated ; then
		return 0
	fi
	return 1
}

src_install() {
	insinto "${dir}"
	doins -r base || die "doins -r base failed"
	doins ChangeLog COPYING manual.pdf || die "doins failed"

	# The executables must be in the same tree as the game data
	exeinto "${dir}"
	if install_client ; then
		# Install client
		newexe ${MY_PN}.x86 ${MY_PN}.bin \
			|| die "newexe ${MY_PN}.x86 failed"
		doicon ${MY_PN}.xpm || die "doicon failed"
		games_make_wrapper ${MY_PN} ./${MY_PN}.bin "${dir}"
		make_desktop_entry ${MY_PN} "Tremulous" ${MY_PN}.xpm
	fi

	if use dedicated ; then
		# Install server
		newexe tremded.x86 ${MY_PN}-ded.bin \
			|| die "newexe tremded.x86 failed"
		games_make_wrapper ${MY_PN}-ded ./${MY_PN}-ded.bin "${dir}"
	fi

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	elog "Read instructions:  http://tremulous.net/manual/"
	elog "or:  ${dir}/manual.pdf"
	echo
}
