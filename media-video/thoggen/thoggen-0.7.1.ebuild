# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/thoggen/thoggen-0.7.1.ebuild,v 1.1 2008/06/19 16:00:13 hanno Exp $

inherit gnome2

DESCRIPTION="DVD ripper, based on GStreamer and Gtk+"
HOMEPAGE="http://thoggen.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=">=gnome-base/libglade-2.4.0
	>=media-libs/gst-plugins-base-0.10.17
	>=media-libs/gst-plugins-good-0.10.7
	>=media-libs/gst-plugins-ugly-0.10.7
	>=media-plugins/gst-plugins-mpeg2dec-0.10.7
	>=media-plugins/gst-plugins-a52dec-0.10.7
	>=media-plugins/gst-plugins-dvdread-0.10.7
	>=media-plugins/gst-plugins-theora-0.10.17
	>=media-plugins/gst-plugins-vorbis-0.10.17
	>=media-plugins/gst-plugins-ogg-0.10.17
	>=sys-apps/hal-0.4
	dev-libs/dbus-glib
	>=media-libs/libdvdread-0.9.4"

pkg_setup() {
	G2CONF="--disable-element-checks"
	DOCS="AUTHORS ChangeLog NEWS README TODO"
}

src_install() {
	gnome2_src_install || die
	rm -rf "${D}/usr/share/doc/${PN}" || die
}
