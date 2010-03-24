# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-v4l2/gst-plugins-v4l2-0.10.17.ebuild,v 1.4 2010/03/24 20:12:32 fauli Exp $

inherit gst-plugins-good

DESCRIPION="plugin to allow capture from video4linux2 devices"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ppc ~ppc64 x86"
IUSE=""

RDEPEND=">=media-libs/gst-plugins-base-0.10.25
	>=media-libs/gstreamer-0.10.25"
DEPEND="${RDEPEND}
	virtual/os-headers"
