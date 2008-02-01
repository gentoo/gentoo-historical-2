# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-taglib/gst-plugins-taglib-0.10.6-r1.ebuild,v 1.2 2008/02/01 12:53:29 drac Exp $

inherit eutils gst-plugins-good

KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=media-libs/gst-plugins-base-0.10.17
	>=media-libs/gstreamer-0.10.17
	>=media-libs/taglib-1.4"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	gst-plugins-good_src_unpack
	epatch "${FILESDIR}"/${P}-sortname.patch
}
