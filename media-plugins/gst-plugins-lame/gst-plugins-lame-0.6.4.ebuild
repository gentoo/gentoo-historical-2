# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-lame/gst-plugins-lame-0.6.4.ebuild,v 1.5 2004/05/29 03:08:42 pvdabeel Exp $

inherit gst-plugins

KEYWORDS="x86 ppc sparc"

IUSE=""
RDEPEND="media-sound/lame"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

