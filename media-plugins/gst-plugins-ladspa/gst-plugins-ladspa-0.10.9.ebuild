# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-ladspa/gst-plugins-ladspa-0.10.9.ebuild,v 1.1 2008/12/05 22:51:09 ssuominen Exp $

inherit gst-plugins-bad

KEYWORDS="~alpha ~amd64 ~x86"
IUSE=""

RDEPEND=">=media-libs/ladspa-sdk-1.12-r2
	>=media-libs/gst-plugins-base-0.10.21
	>=media-libs/gstreamer-0.10.21"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"
