# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-simulation/secondlife-bin/secondlife-bin-1.23.5.ebuild,v 1.1 2009/12/06 19:59:26 lavajoe Exp $

inherit eutils multilib games versionator

SECONDLIFE_REVISION=136262
MY_P="SecondLife-i686-${PV}.${SECONDLIFE_REVISION}"

DESCRIPTION="The Second Life (an online, 3D virtual world) viewer"
HOMEPAGE="http://secondlife.com/"
SRC_URI="http://automated-builds-secondlife-com.s3.amazonaws.com/viewer-rc-frozen/${SECONDLIFE_REVISION}/${MY_P}.tar.bz2"
RESTRICT="mirror strip"

LICENSE="GPL-2-with-Linden-Lab-FLOSS-exception"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Note, used to RDEPEND on:
# media-fonts/kochi-substitute
RDEPEND="sys-libs/glibc
	sys-apps/dbus
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXext
	>=x11-libs/gtk+-2.0
	x11-libs/libXinerama
	dev-libs/libgcrypt
	dev-libs/libgpg-error
	dev-libs/openssl
	dev-libs/apr
	dev-libs/apr-util
	dev-libs/boost
	dev-libs/elfio
	dev-libs/expat
	media-libs/freetype
	media-libs/libogg
	media-libs/libsdl
	media-libs/libvorbis
	media-libs/gstreamer
	media-plugins/gst-plugins-meta
	media-libs/fmod
	x86? ( || ( media-libs/jpeg-compat <media-libs/jpeg-7 ) )
	media-libs/openjpeg
	net-libs/gnutls
	net-misc/curl
	net-dns/c-ares
	sys-libs/zlib
	~virtual/libstdc++-3.3
	virtual/glu
	virtual/opengl
	media-libs/openal
	media-libs/freealut
	amd64? (
		app-emulation/emul-linux-x86-sdl
		app-emulation/emul-linux-x86-gtklibs
	)"

S="${WORKDIR}/${MY_P}"

SECONDLIFE_HOME="${GAMES_PREFIX_OPT}/secondlife"

QA_TEXTRELS="${SECONDLIFE_HOME:1}/bin/libllkdu.so
	${SECONDLIFE_HOME:1}/lib/libkdu.so
	${SECONDLIFE_HOME:1}/lib/libfmod-3.75.so
	${SECONDLIFE_HOME:1}/lib/libvivoxsdk.so
	${SECONDLIFE_HOME:1}/app_settings/mozilla-runtime-linux-i686/libxul.so"
QA_EXECSTACK="${SECONDLIFE_HOME:1}/bin/do-not-directly-run-secondlife-bin
	${SECONDLIFE_HOME:1}/bin/libllkdu.so
	${SECONDLIFE_HOME:1}/lib/libSDL-1.2.so.0
	${SECONDLIFE_HOME:1}/lib/libcrypto.so.0.9.7
	${SECONDLIFE_HOME:1}/lib/libkdu.so
	${SECONDLIFE_HOME:1}/lib/libfmod-3.75.so
	${SECONDLIFE_HOME:1}/app_settings/mozilla-runtime-linux-i686/libxul.so"

pkg_setup() {
	games_pkg_setup

	# x86 binary package, ABI=x86
	has_multilib_profile && ABI="x86"
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# On 64-bit systems, we need to uncomment LL_BAD_OPENAL_DRIVER=x
	# and comment out the amd64 streaming disable to fix streaming audio.
	use amd64 && epatch "${FILESDIR}/${P}-amd64-audio-streaming-fix.patch"
}

src_install() {
	exeinto "${SECONDLIFE_HOME}"
	doexe launch_url.sh secondlife || die
	rm -rf launch_url.sh secondlife

	exeinto "${SECONDLIFE_HOME}"/bin
	doexe bin/* || die
	rm -rf bin

	exeinto "${SECONDLIFE_HOME}"/lib
	doexe lib/* || die
	rm -rf lib

	insinto "${SECONDLIFE_HOME}"
	doins -r * || die "doins * failed"

	#dosym /usr/share/fonts/kochi-substitute/kochi-mincho-subst.ttf "${SECONDLIFE_HOME}"/unicode.ttf

	games_make_wrapper secondlife-bin "./secondlife --set VersionChannelName Gentoo" "${SECONDLIFE_HOME}" "${SECONDLIFE_HOME}"/lib
	make_desktop_entry secondlife-bin "Second Life (binary distribution)" /opt/secondlife/secondlife_icon.png

	prepgamesdirs
}
