# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-v4l2/gst-plugins-v4l2-0.8.9.ebuild,v 1.2 2006/03/02 10:39:34 hanno Exp $

inherit gst-plugins

DESCRIPION="plugin to allow capture from video4linux2 devices"

KEYWORDS="~x86 ~ppc ~amd64"

IUSE=""

RDEPEND="|| ( x11-libs/libXv virtual/x11 )
	>=sys-kernel/linux-headers-2.6"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9"

