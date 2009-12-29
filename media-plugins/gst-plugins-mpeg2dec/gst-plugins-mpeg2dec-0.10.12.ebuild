# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-mpeg2dec/gst-plugins-mpeg2dec-0.10.12.ebuild,v 1.8 2009/12/29 18:17:34 armin76 Exp $

inherit gst-plugins-ugly

DESCRIPTION="Libmpeg2 based decoder plug-in for gstreamer"
KEYWORDS="alpha amd64 arm hppa ia64 ~ppc ppc64 sh sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=">=media-libs/gst-plugins-base-0.10.23
	>=media-libs/gstreamer-0.10.23
	>=media-libs/libmpeg2-0.4"
