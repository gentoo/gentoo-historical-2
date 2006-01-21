# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gst-plugins-bad/gst-plugins-bad-0.10.0.ebuild,v 1.1 2006/01/21 02:03:49 compnerd Exp $

inherit gst-plugins-bad gnome2 eutils flag-o-matic libtool

DESCRIPTION="Unmaintained plugins for GStreamer"
HOMEPAGE="http://gstreamer.freedesktop.org/"
SRC_URI="http://gstreamer.freedesktop.org/src/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

# !! HACK !! : Required to get find_dir to function
GST_PLUGINS_BUILD_DIR=""
GST_PLUGINS_BUILD="qtdemux speed tta"

src_unpack() {
	unpack ${A}
}

src_compile() {
	elibtoolize

	strip-flags
	replace-flags "-O3" "-O2"
	filter-flags "-fprefetch-loop-arrays" # (Bug #22249)

	if use alpha || use amd64 || use ia64 || use hppa ; then
		append-flags -fPIC
	fi

	gst-plugins-bad_src_compile
}
