# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-colorspace/gst-plugins-colorspace-0.6.4.ebuild,v 1.2 2003/10/23 22:41:59 foser Exp $

inherit gst-plugins

KEYWORDS="~x86 ~ppc"

IUSE=""
DEPEND="media-libs/hermes"

BUILD_GST_PLUGINS="hermes"
GST_PLUGINS_BUILD_DIR="hermes"
