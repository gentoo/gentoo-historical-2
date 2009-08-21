# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-annodex/gst-plugins-annodex-0.10.15.ebuild,v 1.2 2009/08/21 11:21:24 leio Exp $

inherit gst-plugins-good

DESCRIPTION="GStreamer plugin for annodex stream manipulation"

KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND=">=media-libs/gst-plugins-base-0.10.23
	>=media-libs/gstreamer-0.10.23
	>=dev-libs/libxml2-2.4.9"
