# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libao/libao-0.8.6-r3.ebuild,v 1.8 2007/01/14 18:55:26 corsair Exp $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit libtool eutils autotools

PATCHLEVEL="4"

DESCRIPTION="the audio output library"
HOMEPAGE="http://www.xiph.org/ao/"
SRC_URI="http://downloads.xiph.org/releases/ao/${P}.tar.gz
	mirror://gentoo/${PN}-patches-${PATCHLEVEL}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="alsa arts esd nas mmap pulseaudio doc"

RDEPEND="alsa? ( media-libs/alsa-lib )
	arts? ( kde-base/arts )
	esd? ( >=media-sound/esound-0.2.22 )
	nas? ( media-libs/nas )"
PDEPEND="pulseaudio? ( media-plugins/libao-pulse )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	EPATCH_SUFFIX="patch" epatch "${WORKDIR}/patches"

	AT_M4DIR="${WORKDIR}/patches/m4" eautoreconf
	elibtoolize
}

src_compile() {
	# this is called alsa09 even if it is alsa 1.0
	econf \
		$(use_enable alsa alsa09) \
		$(use_enable mmap alsa09-mmap) \
		$(use_enable arts) \
		$(use_enable esd) \
		$(use_enable nas) \
		--enable-shared \
		--enable-static \
		|| die

	emake || die
}

src_install () {
	emake -j1 DESTDIR="${D}" install || die

	rm -rf "${D}/usr/share/doc"
	dodoc AUTHORS CHANGES README TODO
	use doc && dohtml -A c doc/*.html
}
