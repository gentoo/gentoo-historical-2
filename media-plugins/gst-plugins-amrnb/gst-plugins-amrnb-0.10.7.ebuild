# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-amrnb/gst-plugins-amrnb-0.10.7.ebuild,v 1.1 2008/02/21 11:19:46 zaheerm Exp $

inherit gst-plugins-ugly

KEYWORDS="~amd64 ~x86"

RDEPEND=">=media-libs/gst-plugins-base-0.10.17
	>=media-libs/gstreamer-0.10.17
	media-libs/amrnb"

DEPEND="${RDEPEND}"
