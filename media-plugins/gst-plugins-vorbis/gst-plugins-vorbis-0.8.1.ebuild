# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-vorbis/gst-plugins-vorbis-0.8.1.ebuild,v 1.8 2004/07/04 13:17:15 kloeri Exp $

inherit gst-plugins

KEYWORDS="x86 ppc alpha ~sparc hppa amd64 ~ia64 mips"

IUSE=""
RDEPEND=">=media-libs/libvorbis-1"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9"
