# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-speex/gst-plugins-speex-0.10.2.ebuild,v 1.5 2006/05/03 20:30:14 gustavoz Exp $

inherit gst-plugins-good

KEYWORDS="~amd64 ~ppc ~ppc64 sparc ~x86"

DESCRIPTION="GStreamer plugin to allow encoding and decoding of speex"

IUSE=""
RDEPEND=">=media-libs/speex-1.1.6"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9"
