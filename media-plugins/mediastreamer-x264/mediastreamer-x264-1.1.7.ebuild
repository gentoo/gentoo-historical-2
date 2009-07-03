# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/mediastreamer-x264/mediastreamer-x264-1.1.7.ebuild,v 1.5 2009/07/03 18:10:07 volkmar Exp $

EAPI="2"

inherit multilib

MY_P="msx264-${PV}"

DESCRIPTION="mediastreamer plugin: add H264 support"
HOMEPAGE="http://www.linphone.org/"
SRC_URI="http://download.savannah.nongnu.org/releases/linphone/plugins/sources/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

DEPEND=">=media-libs/mediastreamer-2.1.0
	>=media-libs/x264-0.0.20080819
	media-video/ffmpeg"
RDEPEND="${DEPEND}
	media-libs/mediastreamer[video]"

S=${WORKDIR}/${MY_P}

src_configure() {
	# strict: don't want -Werror
	# hacked-x264: x264 is not patched with multislicing
	econf \
		--libdir=/usr/$(get_libdir) \
		--disable-strict \
		--disable-hacked-x264 \
		--disable-dependency-tracking
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog NEWS README || die "dodoc failed"
}
