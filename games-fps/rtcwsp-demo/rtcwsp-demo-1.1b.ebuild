# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Header: $

inherit eutils games

MY_P="wolfspdemo-linux-${PV}.x86.run"

DESCRIPTION="Return to Castle Wolfenstein - Single-player demo"
HOMEPAGE="http://games.activision.com/games/wolfenstein/"
SRC_URI="ftp://ftp.idsoftware.com/idstuff/wolf/linux/old/${MY_P}
	mirror://3dgamers/returnwolfenstein/${MY_P}"

LICENSE="RTCW"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="nostrip nomirror"

RDEPEND="sys-libs/glibc
	virtual/opengl
	|| (
		(
			x11-libs/libX11
			x11-libs/libXext
			x11-libs/libXau
			x11-libs/libXdmcp )
		virtual/x11 )
	amd64? (
		app-emulation/emul-linux-x86-xlibs )"

S=${WORKDIR}

GAMES_CHECK_LICENSE="yes"
dir=${GAMES_PREFIX_OPT}/${PN}
Ddir=${D}/${dir}

src_unpack() {
	unpack_makeself ${A} || die "Unpacking files"
}

src_install() {
	insinto "${dir}"
	doins -r demomain Docs

	exeinto "${dir}"
	doexe bin/x86/wolfsp.x86 openurl.sh || die "copying exe"

	games_make_wrapper rtcwmp-demo ./wolfsp.x86 "${dir}" "${dir}"

	doins WolfSP.xpm CHANGES
	newicon WolfSP.xpm rtcwsp-demo.xpm

	prepgamesdirs
	make_desktop_entry rtcwsp-demo "Return to Castle Wolfenstein (SP demo)" \
		rtcwsp-demo.xpm
}

pkg_postinst() {
	games_pkg_postinst
	einfo "Install 'rtcwmp-demo' for multi-player"
	echo
	einfo "Run 'rtcwmp-demo' for single-player"
}
