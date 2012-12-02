# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-x264/gst-plugins-x264-0.10.18.ebuild,v 1.5 2012/12/02 16:42:21 eva Exp $

EAPI="1"

inherit eutils gst-plugins-ugly

KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

# 20100224 ensures us X264_BUILD >= 86, which added presets support
RDEPEND=">=media-libs/x264-0.0.20100224
	>=media-libs/gstreamer-0.10.26:0.10
	>=media-libs/gst-plugins-base-0.10.26:0.10"
DEPEND="${RDEPEND}"
