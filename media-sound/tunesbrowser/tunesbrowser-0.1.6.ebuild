# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/tunesbrowser/tunesbrowser-0.1.6.ebuild,v 1.7 2005/03/02 20:35:08 chainsaw Exp $

IUSE=""

inherit eutils

DESCRIPTION="TunesBrowser is a simple music player, capable of playing music found in iTunes(R) shares"
HOMEPAGE="http://crazney.net/programs/itunes/tunesbrowser.html"
SRC_URI="http://crazney.net/programs/itunes/files/${P}.tar.bz2
	http://dev.gentoo.org/~squinky86/files/${PV}-gstreamer.patch.bz2"

SLOT="0"
LICENSE="crazney"
KEYWORDS="amd64 ppc x86"

DEPEND=">=media-libs/gstreamer-0.8
	>=media-plugins/gst-plugins-mad-0.8
	>=media-plugins/gst-plugins-oss-0.8
	media-libs/libopendaap
	>=gnome-base/libglade-2.0"

src_unpack() {
	unpack ${A}
	cd ${P}.tar.bz2
	epatch ${DISTDIR}/${PV}-gstreamer.patch.bz2
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog
}
