# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-flac/gst-plugins-flac-0.10.3.ebuild,v 1.10 2006/09/04 06:39:14 vapier Exp $

inherit gst-plugins-good

KEYWORDS="alpha amd64 arm hppa ~ia64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND=">=media-libs/flac-1.1.1
	>=media-libs/gstreamer-0.10.5
	>=media-libs/gst-plugins-base-0.10.6"
DEPEND="${RDEPEND}"
