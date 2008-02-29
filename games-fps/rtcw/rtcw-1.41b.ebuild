# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/rtcw/rtcw-1.41b.ebuild,v 1.8 2008/02/29 19:09:05 carlo Exp $

inherit eutils games

MAPS="wolf-linux-goty-maps.x86.run"
DESCRIPTION="Return to Castle Wolfenstein - Long awaited sequel to Wolfenstein 3D"
HOMEPAGE="http://games.activision.com/games/wolfenstein/"
SRC_URI="mirror://3dgamers/returnwolfenstein/Missions/${MAPS}
	mirror://idsoftware/wolf/linux/wolf-linux-${PV}.x86.run"
#	mirror://3dgamers/returnwolfenstein/wolf-linux-${PV}.x86.run

LICENSE="RTCW"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="opengl dedicated"
RESTRICT="strip mirror"

UIDEPEND="virtual/opengl
	x86? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXau
		x11-libs/libXdmcp
	)
	amd64? ( app-emulation/emul-linux-x86-xlibs )"
RDEPEND="sys-libs/glibc
	dedicated? ( app-misc/screen )
	!dedicated? ( ${UIDEPEND} )
	opengl? ( ${UIDEPEND} )
	x86? ( sys-libs/lib-compat )
	amd64? ( app-emulation/emul-linux-x86-compat )"

S=${WORKDIR}

GAMES_CHECK_LICENSE="yes"
dir=${GAMES_PREFIX_OPT}/${PN}
Ddir=${D}/${dir}

src_unpack() {
	unpack_makeself wolf-linux-goty-maps.x86.run
	unpack_makeself wolf-linux-${PV}.x86.run
}

src_install() {
	insinto "${dir}"
	doins -r main Docs pb

	exeinto "${dir}"
	doexe bin/Linux/x86/*.x86 openurl.sh || die "copying exe"

	games_make_wrapper rtcwmp ./wolf.x86 "${dir}" "${dir}"
	games_make_wrapper rtcwsp ./wolfsp.x86 "${dir}" "${dir}"

	if use dedicated; then
		games_make_wrapper wolf-ded ./wolfded.x86 "${dir}" "${dir}"
		newinitd "${FILESDIR}"/wolf-ded.rc wolf-ded
		dosed "s:GENTOO_DIR:${dir}:" /etc/init.d/wolf-ded
	fi

	insinto ${dir}
	doins WolfMP.xpm WolfSP.xpm QUICKSTART CHANGES RTCW-README-1.4.txt
	doicon WolfMP.xpm WolfSP.xpm

	prepgamesdirs
	make_desktop_entry rtcwmp "Return to Castle Wolfenstein (MP)" WolfMP
	make_desktop_entry rtcwsp "Return to Castle Wolfenstein (SP)" WolfSP
}

pkg_postinst() {
	games_pkg_postinst
	ewarn "There are two possible security bugs in this package, both causing a"
	ewarn "denial of service.  One affects the game when running a server, the"
	ewarn "other when running as a client."
	ewarn "For more information, see bug #82149."
	echo
	elog "You need to copy pak0.pk3, mp_pak0.pk3, mp_pak1.pk3, mp_pak2.pk3,"
	elog "sp_pak1.pk3 and sp_pak2.pk3 from a Window installation into ${dir}/main/"
	elog
	elog "To play the game run:"
	elog " rtcwsp (single-player)"
	elog " rtcwmp (multi-player)"
	elog
	if use dedicated
	then
		elog "To start a dedicated server run:"
		elog " /etc/init.d/wolf-ded start"
		elog
		elog "To run the dedicated server at boot, type:"
		elog " rc-update add wolf-ded default"
		elog
		elog "The dedicated server is started under the ${GAMES_USER_DED} user account"
		echo
	fi
}
