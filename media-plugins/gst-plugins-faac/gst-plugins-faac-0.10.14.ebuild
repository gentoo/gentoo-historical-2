# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-faac/gst-plugins-faac-0.10.14.ebuild,v 1.6 2010/01/05 18:32:22 nixnut Exp $

inherit gst-plugins-bad

KEYWORDS="alpha amd64 ppc ppc64 x86"
IUSE=""

RDEPEND="media-libs/faac
	>=media-libs/gst-plugins-base-0.10.24
	>=media-libs/gstreamer-0.10.24"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"
