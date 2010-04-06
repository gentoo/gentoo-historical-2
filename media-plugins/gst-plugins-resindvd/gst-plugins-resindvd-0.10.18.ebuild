# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-resindvd/gst-plugins-resindvd-0.10.18.ebuild,v 1.1 2010/04/06 00:28:58 leio Exp $

inherit gst-plugins-bad

KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND=">=media-libs/libdvdnav-4.1.2
	>=media-libs/gst-plugins-base-0.10.27"
DEPEND="${RDEPEND}"

# The configure option is dvdnav
GST_PLUGINS_BUILD="dvdnav"
