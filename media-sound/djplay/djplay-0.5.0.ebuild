# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/djplay/djplay-0.5.0.ebuild,v 1.2 2008/07/27 21:21:45 carlo Exp $

EAPI=1

inherit autotools eutils qt3

DESCRIPTION="A live DJing application."
HOMEPAGE="http://djplay.sf.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="audiofile cdparanoia mad mpeg" #sdl
#Upstream declared that the sdl use flag won't be supported until version 0.7.0

DEPEND="media-libs/alsa-lib
	x11-libs/qt:3
	=dev-libs/glib-1.2*
	media-libs/libsamplerate
	media-libs/id3lib
	dev-libs/libxml2
	media-plugins/tap-plugins
	media-plugins/swh-plugins
	media-sound/jack-audio-connection-kit
	media-libs/libdjconsole
	media-libs/libogg
	media-libs/libvorbis
	media-libs/libsdl
	audiofile? ( media-libs/audiofile )
	cdparanoia? ( media-sound/cdparanoia )
	mad? ( media-libs/libmad )
	mpeg? ( media-libs/libmpeg3 )"
	#sdl? ( media-libs/libsdl )
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-configure.ac.patch"
	epatch "${FILESDIR}/${P}-libmpeg3.patch"

	eautoconf || die "eautoconf failed"
}

src_compile() {
	local myconf

	if use mpeg; then
		myconf=--with-mpeg3includes=/usr/include/libmpeg3
	fi

	econf \
		${myconf} \
		$(use_with audiofile) \
		$(use_with cdparanoia) \
		$(use_with mad) \
		$(use_with mpeg) \
	|| die "econf failed"
		#$(use_with sdl video) \

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc ChangeLog NEWS README AUTHORS
}
