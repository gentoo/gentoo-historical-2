# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-opus/gst-plugins-opus-0.10.23.ebuild,v 1.10 2013/02/03 13:45:54 ago Exp $

EAPI="5"

inherit gst-plugins-bad

DESCRIPTION="GStreamer plugin for Opus audio codec support"
KEYWORDS="amd64 ~arm ~hppa ~ia64 ppc ppc64 x86 ~amd64-fbsd"
IUSE=""

COMMON_DEPEND=">=media-libs/opus-0.9.4:="
RDEPEND="${COMMON_DEPEND}
	media-plugins/gst-plugins-ogg:${SLOT}"
DEPEND="${COMMON_DEPEND}"
