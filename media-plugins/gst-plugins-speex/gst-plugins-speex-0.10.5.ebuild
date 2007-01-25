# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-speex/gst-plugins-speex-0.10.5.ebuild,v 1.1 2007/01/25 18:21:59 lack Exp $

inherit gst-plugins-good

KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

DESCRIPTION="GStreamer plugin to allow encoding and decoding of speex"

IUSE=""
RDEPEND=">=media-libs/speex-1.1.6
	>=media-libs/gstreamer-0.10.10
	>=media-libs/gst-plugins-base-0.10.10.1"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9"
