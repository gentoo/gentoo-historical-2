# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-mimic/gst-plugins-mimic-0.10.17.ebuild,v 1.3 2010/02/19 18:29:42 armin76 Exp $

inherit gst-plugins-bad

DESCRIPTION="GStreamer plugin for the MIMIC codec"

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=media-libs/gstreamer-0.10.25
	>=media-libs/gst-plugins-base-0.10.25
	>=media-libs/libmimic-1.0.4"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"
