# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-xvideo/gst-plugins-xvideo-0.10.11.ebuild,v 1.5 2007/01/30 07:12:02 jer Exp $

inherit gst-plugins-base

KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ~ppc ~ppc64 ~sh sparc ~x86"
IUSE=""

RDEPEND=">=media-libs/gst-plugins-base-0.10.11
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
