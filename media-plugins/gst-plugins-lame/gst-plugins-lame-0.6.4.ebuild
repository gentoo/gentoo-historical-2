# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-lame/gst-plugins-lame-0.6.4.ebuild,v 1.4 2004/03/15 00:30:08 spider Exp $

inherit gst-plugins

KEYWORDS="x86 ~ppc sparc"

IUSE=""
RDEPEND="media-sound/lame"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

