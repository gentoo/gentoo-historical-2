# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/farsight2/farsight2-0.0.14.ebuild,v 1.11 2011/02/25 22:13:14 nirbheek Exp $

EAPI="2"

DESCRIPTION="Farsight2 is an audio/video conferencing framework specifically designed for Instant Messengers."
HOMEPAGE="http://farsight.freedesktop.org/"
SRC_URI="http://farsight.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
KEYWORDS="alpha amd64 hppa ppc ~ppc64 x86"
IUSE="python test"
SLOT="0"

COMMONDEPEND=">=media-libs/gstreamer-0.10.23
	>=media-libs/gst-plugins-base-0.10.23
	>=dev-libs/glib-2.16
	>=net-libs/libnice-0.0.9[gstreamer]
	<net-libs/libnice-0.1.0
	python? (
		|| ( >=dev-python/pygobject-2.16 >=dev-python/pygtk-2.12 )
		>=dev-python/pygobject-2.12
		>=dev-python/gst-python-0.10.10 )"

RDEPEND="${COMMONDEPEND}
	|| ( >=media-libs/gst-plugins-good-0.10.16
		<media-libs/gst-plugins-bad-0.10.14 )
	>=media-libs/gst-plugins-good-0.10.11
	>=media-libs/gst-plugins-bad-0.10.13"

DEPEND="${COMMONDEPEND}
	test? ( media-plugins/gst-plugins-vorbis
		media-plugins/gst-plugins-speex )
	dev-util/pkgconfig"

src_configure() {
	econf $(use_enable python)
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS README ChangeLog
}
