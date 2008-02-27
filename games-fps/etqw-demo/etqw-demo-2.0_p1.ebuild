# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/etqw-demo/etqw-demo-2.0_p1.ebuild,v 1.1 2008/02/27 19:25:17 wolf31o2 Exp $

inherit eutils games versionator

MY_MAJOR=$(get_major_version)
MY_REV=$(get_version_component_range 3)
MY_BODY="ETQW-demo${MY_MAJOR}-client-full.r${MY_REV/p/}.x86"

DESCRIPTION="Enemy Territory: Quake Wars demo"
HOMEPAGE="http://zerowing.idsoftware.com/linux/etqw/"
SRC_URI="mirror://idsoftware/etqw/${MY_BODY}.run"

# See copyrights.txt
LICENSE="ETQW"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="strip mirror"

DEPEND="app-arch/unzip"
RDEPEND="virtual/opengl
	x86? (
		media-libs/libsdl
		x11-libs/libX11
		x11-libs/libXau
		x11-libs/libXdmcp
		x11-libs/libXext )
	amd64? ( >=app-emulation/emul-linux-x86-sdl-20071114 )"

S=${WORKDIR}
dir=${GAMES_PREFIX_OPT}/${PN}

QA_TEXTRELS="${dir:1}/data/pb/pbsv.so
	${dir:1}/data/pb/pbag.so
	${dir:1}/data/pb/pbcls.so
	${dir:1}/data/pb/pbcl.so
	${dir:1}/data/pb/pbags.so
	${dir:1}/guis/libmojosetupgui_ncurses.so"

QA_EXECSTACK="${dir:1}/data/libstdc++.so.6
	${dir:1}/data/etqwded.x86
	${dir:1}/data/libgcc_s.so.1
	${dir:1}/data/etqw.x86
	${dir:1}/data/etqw-rthread.x86
	${dir:1}/data/libSDL-1.2.id.so.0
	${dir:1}/guis/libmojosetupgui_ncurses.so"

src_unpack() {
	# unpack_makeself cannot detect the version
	tail -c +194885 "${DISTDIR}/${MY_BODY}.run" > ${PN}.zip || die "tail"
	unpack ./${PN}.zip

	rm -f ${PN}.zip || die
}

src_install() {
	insinto "${dir}"
	doins -r * || die "doins"

	cd data
	exeinto "${dir}"/data
	doexe etqw *.x86 etqw-* lib* *.sh || die "doexe"

	games_make_wrapper ${PN} ./etqw.x86 "${dir}"/data "${dir}"/data
	# Matches with desktop entry for enemy-territory-truecombat
	make_desktop_entry ${PN} "Enemy Territory - Quake Wars (Demo)"

	games_make_wrapper ${PN}-ded ./etqwded.x86 "${dir}"/data "${dir}"/data

	prepgamesdirs
}
