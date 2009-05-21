# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-v4l2/gst-plugins-v4l2-0.10.14.ebuild,v 1.6 2009/05/21 19:01:34 ranger Exp $

inherit gst-plugins-good

DESCRIPION="plugin to allow capture from video4linux2 devices"
KEYWORDS="alpha amd64 ppc ppc64 x86"
IUSE=""

RDEPEND=">=media-libs/gst-plugins-base-0.10.22
	>=media-libs/gstreamer-0.10.22"
DEPEND="${RDEPEND}
	virtual/os-headers
	dev-util/pkgconfig"
