# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-taglib/gst-plugins-taglib-0.10.8.ebuild,v 1.7 2008/08/07 22:05:09 klausman Exp $

inherit eutils gst-plugins-good

KEYWORDS="alpha amd64 ppc ppc64 sparc ~x86"
IUSE=""

RDEPEND=">=media-libs/gst-plugins-base-0.10.18
	>=media-libs/gstreamer-0.10.18
	>=media-libs/taglib-1.4"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"
