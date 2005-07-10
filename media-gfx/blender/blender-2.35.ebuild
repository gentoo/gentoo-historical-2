# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/blender/blender-2.35.ebuild,v 1.4 2005/07/10 00:50:38 swegener Exp $

inherit flag-o-matic eutils

#IUSE="sdl jpeg png mozilla truetype static fmod"
IUSE="" #blender-game" # blender-plugin"

DESCRIPTION="3D Creation/Animation/Publishing System"
HOMEPAGE="http://www.blender.org/"
SRC_URI="http://download.blender.org/source/${P}.tar.bz2"

SLOT="0"
LICENSE="|| (GPL-2 BL)"
KEYWORDS="~ppc ~x86 ~amd64"

RDEPEND="virtual/x11
	media-libs/libsdl
	media-libs/jpeg
	media-libs/libpng
	>=media-libs/freetype-2.0
	>=media-libs/openal-20020127
	>=media-libs/libsdl-1.2
	>=media-libs/libvorbis-1.0
	>=dev-libs/openssl-0.9.6
	>=media-gfx/yafray-0.0.6"

DEPEND="dev-util/scons
	${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}/release/plugins
	chmod 755 bmake
}


src_compile() {
	local myconf=""

	replace-flags -march=pentium4 -march=pentium3
	scons -q

	# SDL Support
	#use sdl && myconf="${myconf} --with-sdl=/usr"
	#	|| myconf="${myconf} --without-sdl"

	# Jpeg support
	#use jpeg && myconf="${myconf} --with-libjpeg=/usr"

	# PNG Support
	#use png && myconf="${myconf} --with-libpng=/usr"

	# ./configure points at the wrong mozilla directories and will fail
	# with this enabled. (A simple patch should take care of this)
	#use mozilla && myconf="${myconf} --with-mozilla=/usr"

	# TrueType support (For text objects)
	#use truetype && myconf="${myconf} --with-freetype2=/usr"

	# Build Staticly
	#use static && myconf="${myconf} --enable-blenderstatic"

	# Build the game engine
#	use blender-game && \
	einfo "enabling game engine"
	sed -i -e "s:BUILD_GAMEENGINE = 'false':BUILD_GAMEENGINE = 'true':" \
	config.opts

#	use blender-game || \
#	( einfo "disabling game engine"
#	sed -i -e "s:BUILD_GAMEENGINE = 'true':BUILD_GAMEENGINE = 'false':" \
#	${S}/config.opts )

	# Build the plugin
#	use blender-plugin && \
#	( einfo "enabling mozilla plugin"
#	sed -i -e "s:BUILD_BLENDER_PLUGIN = 'false':BUILD_BLENDER_PLUGIN = 'true':" \
#	config.opts )

	#Solid desn't work with gcc-3.4, ode does, but the physics bridge
	#doesn't work yet
#	use amd64 && sed -i -e "s:solid:ode:" SConstruct

	sed -i -e "s/-O2/${CFLAGS// /\' ,\'}/g" ${S}/SConstruct
	scons ${MAKEOPTS} || die
#	emake || die
#	cd ${S}/release/plugins
#	emake || die

}

src_install() {
	exeinto /usr/bin/
	doexe ${S}/blender
	doexe ${S}/blenderplayer
#	einstall || die

#	exeinto /usr/lib/${PN}/textures
#	doexe ${S}/release/plugins/texture/*.so
#	exeinto /usr/lib/${PN}/sequences
#	doexe ${S}/release/plugins/sequence/*.so

	insinto /usr/share/pixmaps
	doins ${FILESDIR}/${PN}.png
	insinto /usr/share/applications
	doins ${FILESDIR}/${PN}.desktop

	dodoc COPYING INSTALL README release_2*

}
