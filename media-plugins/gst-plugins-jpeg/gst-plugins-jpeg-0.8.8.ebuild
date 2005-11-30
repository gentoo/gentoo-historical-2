# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-jpeg/gst-plugins-jpeg-0.8.8.ebuild,v 1.1.1.1 2005/11/30 10:07:38 chriswhite Exp $

inherit gst-plugins

DESCRIPTION="plug-in to encode and decode jpeg images"

KEYWORDS="x86 ppc amd64 sparc"
IUSE=""

RDEPEND="media-libs/jpeg"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9"
