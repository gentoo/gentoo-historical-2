# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/clanlib/clanlib-0.7.8.ebuild,v 1.3 2004/06/24 22:09:58 agriffis Exp $

inherit flag-o-matic eutils

DESCRIPTION="multi-platform game development library"
HOMEPAGE="http://www.clanlib.org/"
SRC_URI="http://www.clanlib.org/~sphair/download/ClanLib-${PV}-1.tar.bz2"

LICENSE="LGPL-2"
SLOT="0.7"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~amd64"
IUSE="opengl X sdl oggvorbis doc mikmod clanVoice clanJavaScript ipv6"

RDEPEND=">=media-libs/hermes-1.3.2
	media-libs/libpng
	media-libs/jpeg
	opengl? ( virtual/opengl )
	sdl? ( media-libs/libsdl )
	X? ( virtual/x11 )
	mikmod? ( >=media-libs/libmikmod-3.1.9 )
	oggvorbis? ( media-libs/libvorbis )"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

S="${WORKDIR}/ClanLib-${PV}"

src_unpack() {
	unpack ${A}
	cd ${S}
	find . -name .cvsignore -exec rm -f \{\} \;
	epatch "${FILESDIR}/${PV}-port.patch"
	if ! use doc ; then
		sed -i \
			-e '/^SUBDIRS/s:Documentation::' Makefile.in \
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
		--libdir="/usr/lib/${P}" \
		--enable-dyn \
		--enable-clanNetwork \
		--disable-dependency-tracking \
		$(use_enable x86 asm386) \
		$(use_enable doc docs) \
		$(use_enable clanVoice) \
		$(use_enable clanJavaScript) \
		$(use_enable opengl clanGL) \
		$(use_enable sdl clanSDL) \
		$(use_enable oggvorbis clanVorbis) \
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
	mv "${D}"/usr/include/{ClanLib-*/ClanLib,"${P}"}
	rm -rf "${D}/usr/include/ClanLib-"*
	dobin "${FILESDIR}/clanlib-config"
	dodoc CODING_STYLE CREDITS NEWS PATCHES README* INSTALL.linux
}

pkg_postinst() {
	clanlib-config "${PV}"
}
