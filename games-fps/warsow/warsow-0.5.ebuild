# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/warsow/warsow-0.5.ebuild,v 1.2 2009/10/05 17:46:44 mr_bones_ Exp $

EAPI=2
inherit flag-o-matic eutils toolchain-funcs versionator games

MY_P=${PN}_${PV}
DESCRIPTION="Multiplayer FPS based on the QFusion engine (evolved from Quake 2)"
HOMEPAGE="http://www.warsow.net/"
SRC_URI="http://static.warsow.net/release/${MY_P}_unified.zip
	http://static.warsow.net/release/${MY_P}_sdk.zip
	mirror://gentoo/${PN}.png"

LICENSE="GPL-2 warsow"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+angelscript debug dedicated irc openal opengl"

UIRDEPEND="media-libs/jpeg
	media-libs/libvorbis
	media-libs/libsdl
	virtual/opengl
	x11-libs/libXinerama
	x11-libs/libXxf86dga
	x11-libs/libXxf86vm
	openal? ( media-libs/openal )"
RDEPEND="net-misc/curl
	opengl? ( ${UIRDEPEND} )
	!opengl? ( !dedicated? ( ${UIRDEPEND} ) )"
UIDEPEND="x11-proto/xineramaproto
	x11-proto/xf86dgaproto
	x11-proto/xf86vidmodeproto
	openal? ( dev-util/pkgconfig )"
DEPEND="${RDEPEND}
	app-arch/unzip
	x11-misc/makedepend
	opengl? ( ${UIDEPEND} )
	!opengl? ( !dedicated? ( ${UIDEPEND} ) )"

S=${WORKDIR}/source

src_prepare() {
	sed -i \
		-e "/fs_basepath =/ s:\.:${GAMES_DATADIR}/${PN}:" \
		qcommon/files.c \
		|| die "sed files.c failed"

	cd "${WORKDIR}"
	epatch \
		"${FILESDIR}"/${P}-build.patch \
		"${FILESDIR}"/${P}-openal.patch
	strip-flags
}

src_compile() {
	yesno() { use ${1} && echo YES || echo NO ; }

	local client="NO" irc="NO" openal="NO"
	if use opengl || ! use dedicated ; then
		client="YES"
		use irc && irc="YES"
		use openal && openal="YES"
	fi

	tc-export CC AR RANLIB

	if use angelscript ; then
		emake \
			-C ../libsrcs/angelscript/angelSVN/sdk/angelscript/projects/gnuc \
			|| die "emake angelscript failed"
	fi

	emake \
		BINDIR=bin \
		BUILD_CLIENT=${client} \
		BUILD_SERVER=$(yesno dedicated) \
		BUILD_TV_SERVER=$(yesno dedicated) \
		BUILD_ANGELWRAP=$(yesno angelscript) \
		BUILD_IRC=${irc} \
		BUILD_SND_OPENAL=${openal} \
		BUILD_SND_QF=${client} \
		DEBUG_BUILD=$(yesno debug) \
		|| die "emake failed"
}

src_install() {
	cd bin

	if use opengl || ! use dedicated ; then
		newgamesbin ${PN}.* ${PN} || die "newgamesbin ${PN} failed"
		doicon "${DISTDIR}"/${PN}.png
		make_desktop_entry ${PN} Warsow
	fi

	if use dedicated ; then
		newgamesbin wsw_server.* ${PN}-ded || die "newgamesbin ${PN}-ded failed"
		newgamesbin wswtv_server.* ${PN}-tv || die "newgamesbin ${PN}-tv failed"
	fi

	exeinto "$(games_get_libdir)"/${PN}
	doexe */*.so || die "doexe failed"

	insinto "${GAMES_DATADIR}"/${PN}
	doins -r "${WORKDIR}"/basewsw || die "doins failed"

	local so
	for so in basewsw/*.so ; do
		dosym "$(games_get_libdir)"/${PN}/${so##*/} \
			"${GAMES_DATADIR}"/${PN}/${so} || die "dosym ${so} failed"
	done

	if [[ -e libs ]] ; then
		dodir "${GAMES_DATADIR}"/${PN}/libs
		for so in libs/*.so ; do
			dosym "$(games_get_libdir)"/${PN}/${so##*/} \
				"${GAMES_DATADIR}"/${PN}/${so} || die "dosym ${so} failed"
		done
	fi

	dodoc "${WORKDIR}"/docs/*
	prepgamesdirs
}
