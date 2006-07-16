# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-mad/gst-plugins-mad-0.10.3.ebuild,v 1.10 2006/07/16 12:00:48 dertobi123 Exp $

inherit gst-plugins-ugly

KEYWORDS="alpha ~amd64 hppa ppc ppc64 sparc x86"
IUSE=""

RDEPEND=">=media-libs/gst-plugins-base-0.10.3
	>=media-libs/gstreamer-0.10.3
	>=media-libs/libmad-0.15.1b
	>=media-libs/libid3tag-0.15"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"
