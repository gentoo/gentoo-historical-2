# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-jpeg/gst-plugins-jpeg-0.10.16.ebuild,v 1.8 2010/01/05 18:20:11 nixnut Exp $

inherit gst-plugins-good

DESCRIPTION="GStreamer encoder/decoder for JPEG format"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86"
IUSE=""

RDEPEND="media-libs/jpeg
	>=media-libs/gstreamer-0.10.24
	>=media-libs/gst-plugins-base-0.10.24"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"
