# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/clanlib/clanlib-0.7.8-r1.ebuild,v 1.7 2006/01/13 22:00:39 genstef Exp $

inherit flag-o-matic eutils

DESCRIPTION="multi-platform game development library"
HOMEPAGE="http://www.clanlib.org/"
SRC_URI="http://www.clanlib.org/download/files/ClanLib-${PV}-1.tar.bz2"

LICENSE="LGPL-2"
SLOT="0.7"
KEYWORDS="amd64 x86" #not big endian safe #82779
IUSE="opengl X sdl vorbis doc mikmod clanVoice clanJavaScript ipv6"

DEPEND="virtual/libc
	media-libs/libpng
	media-libs/jpeg
	media-libs/freetype
	opengl? ( virtual/opengl )
	sdl? ( media-libs/libsdl )
	X? (
		|| (
			( media-libs/mesa
			x11-libs/libX11
			x11-libs/libXt
			x11-proto/inputproto
			x11-proto/xf86vidmodeproto
			x11-proto/xproto )
			virtual/x11
		)
	)
	mikmod? ( >=media-libs/libmikmod-3.1.9 )
	vorbis? ( media-libs/libvorbis )"
RDEPEND="${DEPEND}
	|| (
		( media-libs/mesa
		x11-libs/libX11
		x11-libs/libXmu
		x11-libs/libXxf86vm )
		virtual/x11
	)"

S="${WORKDIR}/ClanLib-${PV}"

src_unpack() {
	unpack ${A}
	cd ${S}
	find . -name .cvsignore -exec rm -f '{}' \;
	epatch "${FILESDIR}"/${PV}-port.patch
	epatch "${FILESDIR}"/${PV}-install-opengl-wrap.patch
	if ! use doc ; then
		sed -i \
			-e '/^SUBDIRS/s:Documentation::' \
			Makefile.in \
			|| die "sed Makefile.in failed"
	fi
}

src_compile() {
	#clanSound only controls mikmod/vorbis so there's
	# no need to pass --{en,dis}able-clanSound ...
	#clanDisplay only controls X, SDL, OpenGL plugins
	# so no need to pass --{en,dis}able-clanDisplay
	# also same reason why we don't have to use clanGUI
	econf \
		--enable-dyn \
		--enable-clanNetwork \
		--disable-dependency-tracking \
		$(use_enable x86 asm386) \
		$(use_enable doc docs) \
		$(use_enable clanVoice) \
		$(use_enable clanJavaScript) \
		$(use_enable opengl clanGL) \
		$(use_enable sdl clanSDL) \
		$(use_enable vorbis clanVorbis) \
		$(use_enable mikmod clanMikMod) \
		$(use_enable ipv6 getaddr) \
		|| die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	if use doc ; then
		dodir "/usr/share/doc/${PF}/html"
		mv "${D}/usr/share/doc/clanlib/"* "${D}/usr/share/doc/${PF}/html/"
		rm -rf "${D}/usr/share/doc/clanlib"
		cp -r Examples "${D}/usr/share/doc/${PF}/"
	fi
	dodoc CODING_STYLE CREDITS NEWS PATCHES README* INSTALL.linux
}
