# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-cdio/gst-plugins-cdio-0.10.11.ebuild,v 1.5 2009/05/21 15:32:02 ranger Exp $

inherit gst-plugins-ugly

KEYWORDS="alpha amd64 ppc ~ppc64 x86 ~x86-fbsd"
IUSE=""

DEPEND=">=dev-libs/libcdio-0.80
	>=media-libs/gst-plugins-base-0.10.22
	>=media-libs/gstreamer-0.10.22"
