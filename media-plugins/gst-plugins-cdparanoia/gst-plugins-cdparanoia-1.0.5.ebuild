# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-cdparanoia/gst-plugins-cdparanoia-1.0.5.ebuild,v 1.5 2013/02/21 21:47:10 ago Exp $

EAPI="5"

inherit gst-plugins-base gst-plugins10

KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ppc ~ppc64 ~sparc x86"
IUSE=""

RDEPEND=">=media-sound/cdparanoia-3.10.2-r3"
DEPEND="${RDEPEND}"

src_prepare() {
	gst-plugins10_system_link gst-libs/gst/audio:gstreamer-audio
}
