# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-modplug/gst-plugins-modplug-0.10.14.ebuild,v 1.3 2009/11/17 21:06:15 ranger Exp $

inherit gst-plugins-bad

KEYWORDS="~alpha amd64 ~ppc ppc64 ~x86"
IUSE=""

RDEPEND="media-libs/libmodplug
	>=media-libs/gstreamer-0.10.24
	>=media-libs/gst-plugins-base-0.10.24"
DEPEND="${RDEPEND}
	!<media-libs/gst-plugins-bad-0.10.11"
