# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-ogg/gst-plugins-ogg-0.8.11.ebuild,v 1.6 2006/01/23 16:28:16 wolf31o2 Exp $

inherit gst-plugins

KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

RDEPEND=">=media-libs/libogg-1"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9"
