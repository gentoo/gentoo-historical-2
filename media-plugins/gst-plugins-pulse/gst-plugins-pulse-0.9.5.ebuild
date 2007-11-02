# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-pulse/gst-plugins-pulse-0.9.5.ebuild,v 1.1 2007/11/02 19:32:02 drac Exp $

MY_PN=gst-pulse

DESCRIPTION="gst-pulse is a GStreamer 0.10 plugin for the PulseAudio sound server."
HOMEPAGE="http://0pointer.de/lennart/projects/gst-pulse/"
SRC_URI="http://0pointer.de/lennart/projects/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0.10"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-sound/pulseaudio-${PV}
	=media-libs/gstreamer-0.10*"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}"/${MY_PN}-${PV}

src_compile() {
	econf --disable-lynx
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dohtml -r doc
	dodoc README
}
