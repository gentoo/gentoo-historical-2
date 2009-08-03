# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/jack-rack/jack-rack-1.4.6.ebuild,v 1.7 2009/08/03 12:57:38 ssuominen Exp $

WANT_AUTOMAKE="1.9"

inherit autotools eutils

DESCRIPTION="JACK Rack is an effects rack for the JACK low latency audio API."
HOMEPAGE="http://jack-rack.sourceforge.net/"
SRC_URI="mirror://sourceforge/jack-rack/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE="alsa gnome lash nls xml"

RDEPEND=">=x11-libs/gtk+-2
	>=media-libs/ladspa-sdk-1.12
	media-sound/jack-audio-connection-kit
	alsa? ( media-libs/alsa-lib )
	lash? ( >=media-sound/lash-0.5 )
	gnome? ( >=gnome-base/libgnomeui-2 )
	nls? ( virtual/libintl )
	xml? ( dev-libs/libxml2
		media-libs/liblrdf )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-1.4.5-asneeded.patch
	epatch "${FILESDIR}"/${P}-no-disable-deprecated.patch
	epatch "${FILESDIR}"/${P}-noalsa.patch
	eautomake
}

src_compile() {
	local myconf
	myconf="--disable-ladcca --enable-desktop-inst"

	econf \
		$(use_enable alsa aseq) \
		$(use_enable gnome) \
		$(use_enable lash) \
		$(use_enable nls) \
		$(use_enable xml) \
		$(use_enable xml lrdf ) \
		--disable-dependency-tracking \
		${myconf}
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS BUGS ChangeLog NEWS README THANKS TODO WISHLIST
}
