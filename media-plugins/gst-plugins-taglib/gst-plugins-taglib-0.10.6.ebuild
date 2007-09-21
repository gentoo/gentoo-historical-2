# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-taglib/gst-plugins-taglib-0.10.6.ebuild,v 1.4 2007/09/21 19:28:01 wolf31o2 Exp $

inherit gst-plugins-good

KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND=">=media-libs/gst-plugins-base-0.10.13
	>=media-libs/gstreamer-0.10.13
	>=media-libs/taglib-1.4"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"
