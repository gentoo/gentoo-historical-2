# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-ximagesrc/gst-plugins-ximagesrc-0.10.17.ebuild,v 1.2 2010/03/19 09:32:33 pacho Exp $

inherit gst-plugins-good

KEYWORDS="amd64 ~ppc ~ppc64 ~x86"

IUSE=""
RDEPEND=">=media-libs/gst-plugins-base-0.10.25
	>=media-libs/gstreamer-0.10.25
	x11-libs/libX11
	x11-libs/libXdamage
	x11-libs/libXfixes"
DEPEND="${RDEPEND}
	x11-proto/xproto"

# xshm is a compile time option of ximage
GST_PLUGINS_BUILD="x xshm"
GST_PLUGINS_BUILD_DIR="ximage"
