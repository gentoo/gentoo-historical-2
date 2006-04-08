# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-x/gst-plugins-x-0.10.4.ebuild,v 1.5 2006/04/08 11:54:56 dertobi123 Exp $

inherit gst-plugins-base

KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"

IUSE=""
RDEPEND=">=media-libs/gst-plugins-base-0.10.4-r1
	 || ( x11-libs/libX11 virtual/x11 )"
DEPEND="${RDEPEND}
	|| ( x11-proto/xproto virtual/x11 )"

# xshm is a compile time option of ximage
GST_PLUGINS_BUILD="x xshm"
GST_PLUGINS_BUILD_DIR="ximage"
