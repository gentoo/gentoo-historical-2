# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-xvideo/gst-plugins-xvideo-0.10.2.ebuild,v 1.1 2006/01/18 02:40:59 compnerd Exp $

inherit gst-plugins-base

KEYWORDS="~x86 ~amd64"

IUSE=""
DEPEND="|| ( x11-libs/libXv virtual/x11 )"

# xshm is a compile time option of xvideo
GST_PLUGINS_BUILD="x xvideo xshm"
GST_PLUGINS_BUILD_DIR="xvimage"
