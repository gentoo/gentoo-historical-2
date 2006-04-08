# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-xvideo/gst-plugins-xvideo-0.10.4-r1.ebuild,v 1.5 2006/04/08 11:59:25 dertobi123 Exp $

inherit gst-plugins-base

KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"

IUSE=""
RDEPEND=">=media-libs/gst-plugins-base-0.10.4
		 || ( x11-libs/libXv virtual/x11 )"
DEPEND="${RDEPEND}
	|| ( ( x11-proto/videoproto
		x11-proto/xproto
		x11-proto/xextproto )
	virtual/x11 )"

# xshm is a compile time option of xvideo
# x is needed to build any X plugins, but we build/install only xv anyway
GST_PLUGINS_BUILD="x xvideo xshm"
GST_PLUGINS_BUILD_DIR="xvimage"
