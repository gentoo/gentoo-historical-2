# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-farsight/gst-plugins-farsight-0.12.11.ebuild,v 1.2 2009/03/31 15:58:53 mr_bones_ Exp $

inherit gst-plugins10

DESCRIPTION="GStreamer plugin for Farsight"
HOMEPAGE="http://farsight.freedesktop.org/"
SRC_URI="http://farsight.freedesktop.org/releases/${PN}/${P}.tar.gz"

GST_MAJOR=0.10
SLOT=${GST_MAJOR}

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ia64 ~sparc ~x86"
IUSE="jpeg2k gsm jingle msn yahoo"

DEPEND=">=media-libs/gstreamer-0.10.22
	>=media-libs/gst-plugins-base-0.10.22
	dev-libs/libxml2
	jpeg2k? ( media-libs/jasper )
	gsm? ( media-sound/gsm )
	jingle? ( net-libs/libjingle )
	msn? ( media-libs/libmimic )
	yahoo? ( media-libs/libj2k )"

src_compile() {
	econf \
		--enable-g729 \
		--disable-jrtplib \
		$(use_enable jpeg2k jasper) \
		$(use_enable gsm) \
		$(use_enable jingle jingle-p2p) \
		$(use_with yahoo libj2k) ||  die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS ChangeLog README

	rm -f "${D}/usr/lib*/*gstreamer*/*jpeg2k*"
}
