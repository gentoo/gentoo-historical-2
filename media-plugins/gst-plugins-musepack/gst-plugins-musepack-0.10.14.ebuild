# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-musepack/gst-plugins-musepack-0.10.14.ebuild,v 1.6 2009/11/29 17:39:42 klausman Exp $

inherit gst-plugins-bad

KEYWORDS="alpha amd64 ~ppc ppc64 x86"
IUSE=""

RDEPEND=">=media-libs/gst-plugins-base-0.10.24
	>=media-libs/gstreamer-0.10.24
	>=media-sound/musepack-tools-444"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"
