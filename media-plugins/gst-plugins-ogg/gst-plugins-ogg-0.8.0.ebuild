# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-ogg/gst-plugins-ogg-0.8.0.ebuild,v 1.8 2004/05/02 21:14:41 geoman Exp $

inherit gst-plugins

KEYWORDS="~x86 ~ppc ~sparc amd64 ~hppa ~alpha ~ia64 ~mips"

IUSE=""
RDEPEND=">=media-libs/libogg-1"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9"

