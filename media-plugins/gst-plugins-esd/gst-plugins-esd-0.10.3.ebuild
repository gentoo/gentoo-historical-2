# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-esd/gst-plugins-esd-0.10.3.ebuild,v 1.9 2007/01/31 19:19:48 corsair Exp $

inherit gst-plugins-good

KEYWORDS="~alpha amd64 arm hppa ~ia64 ~ppc ppc64 sh sparc ~x86"
IUSE=""

RDEPEND=">=media-sound/esound-0.2.8
	>=media-libs/gstreamer-0.10.5
	>=media-libs/gst-plugins-base-0.10.6"
DEPEND="${RDEPEND}"
