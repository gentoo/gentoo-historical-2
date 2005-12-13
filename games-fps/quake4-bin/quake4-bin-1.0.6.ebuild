# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/quake4-bin/quake4-bin-1.0.6.ebuild,v 1.1 2005/12/13 18:58:37 wolf31o2 Exp $

inherit eutils games

DESCRIPTION="Sequel to Quake 2, an Id 3D first-person shooter"
HOMEPAGE="http://www.quake4game.com/"
SRC_URI="mirror://3dgamers/quake4/quake4-linux-${PV}.x86.run
	ftp://ftp.idsoftware.com/idstuff/quake4/linux/quake4-linux-${PV}.x86.run
	ftp://dl.xs4all.nl/pub/mirror/idsoftware/idstuff/quake4/linux/quake4-linux-${PV}.x86.run
	http://filebase.gmpf.de/quake4/quake4-linux-${PV}.x86.run
	http://www.holarse.de/mirror/quake4-linux-${PV}.x86.run"

LICENSE="QUAKE4"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="cdinstall alsa opengl dedicated"
RESTRICT="nostrip"

DEPEND="app-arch/bzip2
	app-arch/tar"
RDEPEND="sys-libs/glibc
	!amd64? ( media-libs/libsdl )
	amd64? ( app-emulation/emul-linux-x86-sdl
		app-emulation/emul-linux-x86-xlibs )
	opengl? ( virtual/opengl )
	dedicated? ( app-misc/screen )
	alsa? ( >=media-libs/alsa-lib-1.0.6 )
	cdinstall? ( games-fps/quake4-data )"

S=${WORKDIR}

GAMES_CHECK_LICENSE="yes"
dir=${GAMES_PREFIX_OPT}/quake4
Ddir=${D}/${dir}

src_unpack() {
	unpack_makeself quake4-linux-${PV}.x86.run
}

src_install() {
	insinto "${dir}"
	doins License.txt README q4icon.bmp us/version.info # CHANGES
	exeinto "${dir}"
	doexe openurl.sh || die "openurl.sh"
	if use x86; then
		doexe bin/Linux/x86/quake4.x86 bin/Linux/x86/q4ded.x86 \
			bin/Linux/x86/libgcc_s.so.1 bin/Linux/x86/libstdc++.so.5 \
			|| die "doexe x86 exes/libs"
	elif use amd64; then
		doexe bin/Linux/x86_64/quake4.x86 bin/Linux/x86_64/q4ded.x86 \
			bin/Linux/x86_64/libgcc_s.so.1 bin/Linux/x86_64/libstdc++.so.5 \
			|| die "doexe amd64 exes/libs"
	else
		die "Cannot copy executables!"
	fi

	insinto "${dir}"/pb
	doins pb/* || die "doins pb"
	insinto "${dir}"/q4base
	if use dedicated
	then
		doins q4base/* || die "doins q4base"
		games_make_wrapper quake4-ded ./q4ded.x86 "${dir}" "${dir}"
	else
		doins q4base/game100.pk4 || die "doins q4base"
	fi
	doins us/q4base/* || die "installing us/q4base/*"

	if use opengl
	then
		games_make_wrapper quake4 ./quake4.x86 "${dir}" "${dir}"
		newicon q4icon.bmp quake4.bmp || die "copying icon"
		make_desktop_entry quake4 "Quake IV" /usr/share/pixmaps/quake4.bmp
	fi

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	if ! use cdinstall; then
		einfo "You need to copy pak001.pk4 through pak012.pk4, along with"
		einfo "zpak*.pk4 from either your installation media or your hard drive"
		einfo "to ${dir}/q4base before running the game."
	fi
	echo
	einfo "To play the game run:"
	einfo " quake4"
	echo
}
