# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-cdparanoia/gst-plugins-cdparanoia-0.10.4.ebuild,v 1.1 2006/03/11 22:55:44 compnerd Exp $

inherit gst-plugins-base

KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-sound/cdparanoia"

src_unpack() {
	unpack ${A}
}

src_compile() {
	gst-plugins-base_src_configure

	# We need to build the entire set of plugins as well to satisfy the build
	emake || die "build failed"
}
