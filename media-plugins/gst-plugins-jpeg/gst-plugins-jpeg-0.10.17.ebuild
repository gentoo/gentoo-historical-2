# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-jpeg/gst-plugins-jpeg-0.10.17.ebuild,v 1.6 2010/04/18 15:46:03 nixnut Exp $

inherit gst-plugins-good

DESCRIPTION="GStreamer encoder/decoder for JPEG format"
KEYWORDS="alpha amd64 ~arm ~hppa ppc ~ppc64 sparc x86"
IUSE=""

RDEPEND="media-libs/jpeg
	>=media-libs/gstreamer-0.10.25
	>=media-libs/gst-plugins-base-0.10.25"
DEPEND="${RDEPEND}"
