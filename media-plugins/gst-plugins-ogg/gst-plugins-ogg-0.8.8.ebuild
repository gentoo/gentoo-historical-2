# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-ogg/gst-plugins-ogg-0.8.8.ebuild,v 1.4 2005/04/29 22:59:12 gustavoz Exp $

inherit gst-plugins

KEYWORDS="x86 ~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc sparc ~ppc64"
IUSE=""

RDEPEND=">=media-libs/libogg-1"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9"
