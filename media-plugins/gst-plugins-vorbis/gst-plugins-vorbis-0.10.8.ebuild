# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-vorbis/gst-plugins-vorbis-0.10.8.ebuild,v 1.3 2006/09/19 16:34:14 agriffis Exp $

inherit eutils gst-plugins-base

KEYWORDS="~alpha ~amd64 ~arm ~hppa ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND=">=media-libs/libvorbis-1
	 >=media-libs/libogg-1
	 >=media-libs/gst-plugins-base-0.10.8"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9"
