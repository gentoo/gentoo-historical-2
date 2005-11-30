# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-pango/gst-plugins-pango-0.8.8-r1.ebuild,v 1.1.1.1 2005/11/30 10:07:24 chriswhite Exp $

inherit gst-plugins

KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"

IUSE=""
DEPEND="x11-libs/pango"

src_unpack() {

	gst-plugins_src_unpack

	cd ${S}/ext/pango
	# fix subtitle crop at bottom
	epatch ${FILESDIR}/${P}-sub_position.patch

}
