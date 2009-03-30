# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-amrwb/gst-plugins-amrwb-0.10.11.ebuild,v 1.1 2009/03/30 04:43:51 tester Exp $

inherit gst-plugins-bad

KEYWORDS="~alpha ~amd64 ~x86"
IUSE=""

RDEPEND=">=media-libs/gst-plugins-base-0.10.22
	>=media-libs/gstreamer-0.10.22
	media-libs/amrwb"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"
