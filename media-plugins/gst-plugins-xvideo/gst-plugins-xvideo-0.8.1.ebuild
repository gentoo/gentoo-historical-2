# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-xvideo/gst-plugins-xvideo-0.8.1.ebuild,v 1.6 2005/03/11 19:35:07 lanius Exp $

inherit gst-plugins

KEYWORDS="x86 ppc amd64"

IUSE=""
DEPEND="virtual/x11"

# xshm is a compile time option of xvideo
GST_PLUGINS_BUILD="x xvideo xshm"
GST_PLUGINS_BUILD_DIR="xvimage"
