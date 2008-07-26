# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-flac/gst-plugins-flac-0.10.8.ebuild,v 1.2 2008/07/26 20:32:12 tester Exp $

inherit gst-plugins-good

KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"

DEPEND="media-libs/flac
	>=media-libs/gstreamer-0.10.18
	>=media-libs/gst-plugins-base-0.10.18"
