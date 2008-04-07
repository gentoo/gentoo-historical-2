# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/farsight/farsight-0.1.26.ebuild,v 1.2 2008/04/07 13:27:34 tester Exp $

DESCRIPTION="FarSight is an audio/video conferencing framework specifically designed for Instant Messengers."
HOMEPAGE="http://farsight.freedesktop.org/"
SRC_URI="http://farsight.freedesktop.org/releases/${PN}/${P}.tar.gz"
#EDARCS_REPO_URI="http://projects.collabora.co.uk/darcs/farsight/farsight"

LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"
IUSE="jingle doc test"
# msn yahoo
SLOT="0"

RDEPEND="=media-libs/gstreamer-0.10*
	>=media-libs/gstreamer-0.10.13
	=media-plugins/gst-plugins-farsight-0.12.6
	>=dev-libs/glib-2.6
	!<net-voip/telepathy-stream-engine-0.5.0
	dev-libs/libxml2
	doc? ( >=dev-util/gtk-doc-1.5 )
	jingle? ( >=net-libs/libjingle-0.3.11 )
	test? ( >=dev-libs/check-0.9.4 )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	=media-libs/gst-plugins-base-0.10*
	=media-libs/gst-plugins-good-0.10*
	=media-plugins/gst-plugins-ffmpeg-0.10*"

src_compile() {
	# I'm disabling clinkc because it sucks, isnt in portage
	# and I couldnt care less for upnp
	econf --enable-rtp \
		--disable-clinkc \
		$(use_enable doc) \
		$(use_enable jingle jingle-p2p) || die "econf failed"
	# Not yet ported to the new version
	# $(use_enable msn msnwebcam) \
	# $(use_enable msn msnavconf) \
	# $(use_enable yahoo yahoowebcam) \
	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS README TODO
}
