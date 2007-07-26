# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-jpeg/gst-plugins-jpeg-0.10.5.ebuild,v 1.2 2007/07/26 14:03:48 gustavoz Exp $

inherit gst-plugins-good

DESCRIPTION="plug-in to encode and decode jpeg images"

KEYWORDS="~amd64 ~ppc ~ppc64 sparc ~x86"
IUSE=""

RDEPEND="media-libs/jpeg
	>=media-libs/gstreamer-0.10.10
	>=media-libs/gst-plugins-base-0.10.10.1"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9"
