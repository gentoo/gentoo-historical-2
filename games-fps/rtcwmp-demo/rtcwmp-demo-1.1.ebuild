# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Header: $

inherit eutils games

MY_P="wolfmpdemo-linux-${PV}-MP.x86.run"

DESCRIPTION="Return to Castle Wolfenstein - Multi-player demo"
HOMEPAGE="http://games.activision.com/games/wolfenstein/"
SRC_URI="ftp://ftp.idsoftware.com/idstuff/wolf/linux/old/${MY_P}
	mirror://3dgamers/returnwolfenstein/${MY_P}"

LICENSE="RTCW"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="dedicated opengl"
RESTRICT="nostrip nomirror"

RDEPEND="sys-libs/glibc
	dedicated? (
		app-misc/screen )
	!dedicated? (
		virtual/opengl
		|| (
			(
				x11-libs/libX11
				x11-libs/libXext
				x11-libs/libXau
				x11-libs/libXdmcp )
			virtual/x11 ) )
	opengl? (
		virtual/opengl
		|| (
			(
				x11-libs/libX11
				x11-libs/libXext
				x11-libs/libXau
				x11-libs/libXdmcp )
			virtual/x11 ) )
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
	doexe bin/x86/*.x86 openurl.sh || die "copying exe"

	games_make_wrapper rtcwmp-demo ./wolf.x86 "${dir}" "${dir}"

	if use dedicated; then
		games_make_wrapper rtcwmp-demo-ded ./wolfded.x86 "${dir}" "${dir}"
		exeinto /etc/init.d
		newexe "${FILESDIR}"/rtcwmp-demo-ded.rc rtcwmp-demo-ded
		dosed "s:GENTOO_DIR:${dir}:" /etc/init.d/rtcwmp-demo-ded
	fi

	doins WolfMP.xpm CHANGES QUICKSTART
	newicon WolfMP.xpm rtcwmp-demo.xpm

	prepgamesdirs
	make_desktop_entry rtcwmp-demo "Return to Castle Wolfenstein (MP demo)" \
		rtcwmp-demo.xpm
}

pkg_postinst() {
	games_pkg_postinst
	einfo "Install 'rtcwsp-demo' for single-player"
	echo
	einfo "Run 'rtcwmp-demo' for multi-player"
	if use dedicated; then
		echo
		einfo "Start a dedicated server with"
		einfo "'/etc/init.d/rtcwmp-demo-ded start'"
		echo
		einfo "Start the server at boot with"
		einfo "'rc-update add rtcwmp-demo-ded default'"
	fi
}
