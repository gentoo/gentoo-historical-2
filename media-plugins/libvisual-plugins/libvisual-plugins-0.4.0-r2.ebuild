# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/libvisual-plugins/libvisual-plugins-0.4.0-r2.ebuild,v 1.11 2012/02/08 14:56:50 jer Exp $

EAPI=1
inherit eutils autotools

PATCHLEVEL="4"

DESCRIPTION="Visualization plugins for use with the libvisual framework."
HOMEPAGE="http://libvisual.sourceforge.net/"
SRC_URI="mirror://sourceforge/libvisual/${P}.tar.gz
	mirror://gentoo/${P}-patches-${PATCHLEVEL}.tar.bz2
	mirror://gentoo/${P}-m4-1.tar.bz2"
LICENSE="GPL-2"

SLOT="0.4"
KEYWORDS="amd64 ~hppa ~mips ppc ppc64 x86 ~x86-fbsd"
IUSE="alsa debug esd gtk jack mplayer opengl"

RDEPEND="~media-libs/libvisual-${PV}
	opengl? ( virtual/opengl )
	esd? ( media-sound/esound )
	jack? ( >=media-sound/jack-audio-connection-kit-0.98 )
	gtk? ( x11-libs/gtk+:2 )
	alsa? ( media-libs/alsa-lib )
	media-libs/fontconfig
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender"
DEPEND="${RDEPEND}
	x11-libs/libXt
	>=dev-util/pkgconfig-0.14"

src_unpack() {
	unpack ${A}
	sed -i -e "s:@MKINSTALLDIRS@:${S}/mkinstalldirs:" "${S}"/po/Makefile.*

	cd "${S}"

	EPATCH_SUFFIX="patch" epatch "${WORKDIR}/patches"
	AT_M4DIR="${WORKDIR}/m4" eautoreconf
}

src_compile() {
	econf $(use_enable debug) \
		$(use_enable debug inputdebug) \
		$(use_enable gtk gdkpixbuf-plugin) \
		$(use_enable alsa) \
		$(use_enable opengl gltest) \
		$(use_enable opengl madspin) \
		$(use_enable opengl flower) \
		$(use_enable opengl nastyfft) \
		$(use_enable mplayer) \
		$(use_enable esd) \
		$(use_enable jack) \
		--enable-static --disable-gstreamer-plugin \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
