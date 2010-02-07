# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-resindvd/gst-plugins-resindvd-0.10.14.ebuild,v 1.2 2010/02/07 21:32:47 armin76 Exp $

inherit gst-plugins-bad

KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND=">=media-libs/libdvdnav-4.1.2
	>=media-libs/gstreamer-0.10.24
	>=media-libs/gst-plugins-base-0.10.24"
DEPEND="${RDEPEND}"

# The configure option is dvdnav
GST_PLUGINS_BUILD="dvdnav"
