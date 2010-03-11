# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/gstreamermm/gstreamermm-0.10.6.ebuild,v 1.2 2010/03/11 12:27:06 flameeyes Exp $

EAPI=2

inherit gnome2

DESCRIPTION="C++ interface for GStreamer"
HOMEPAGE="http://gstreamer.freedesktop.org/bindings/cplusplus.html"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# gstreamer 0.10.25 is needed for per-stream volume
# see bug #308935
RDEPEND="
	>=media-libs/gstreamer-0.10.25
	>=media-libs/gst-plugins-base-0.10.25
	>=dev-cpp/glibmm-2.21.1
	>=dev-cpp/libxmlpp-2.14
	>=dev-libs/libsigc++-2.0"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_test() {
	# explicitly allow parallel make of tests: they are not built in
	# src_compile() and indeed we'd slow down tremendously to run this
	# serially.
	emake check || die "tests failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS ChangeLog NEWS README || die

	find . -name '*.la' -delete
}
