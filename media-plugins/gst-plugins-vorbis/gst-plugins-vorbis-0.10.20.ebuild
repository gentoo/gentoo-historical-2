# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-vorbis/gst-plugins-vorbis-0.10.20.ebuild,v 1.5 2008/07/31 18:49:25 armin76 Exp $

inherit gst-plugins-base

KEYWORDS="~alpha amd64 ~arm ~hppa ia64 ppc ppc64 ~sh sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=media-libs/gst-plugins-base-0.10.20
	media-libs/libvorbis
	media-libs/libogg"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"
