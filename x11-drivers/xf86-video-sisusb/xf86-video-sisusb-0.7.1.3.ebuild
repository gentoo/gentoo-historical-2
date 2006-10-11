# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-sisusb/xf86-video-sisusb-0.7.1.3.ebuild,v 1.11 2006/10/11 00:27:01 dberkholz Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="SiS USB video driver"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ppc64 ~sh ~sparc x86"
RDEPEND="x11-base/xorg-server"
DEPEND="${RDEPEND}
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/videoproto
	x11-proto/xextproto
	x11-proto/xf86miscproto
	x11-proto/xineramaproto
	x11-proto/xproto"
