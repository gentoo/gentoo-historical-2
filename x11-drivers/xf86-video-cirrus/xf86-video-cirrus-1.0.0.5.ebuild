# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-cirrus/xf86-video-cirrus-1.0.0.5.ebuild,v 1.9 2006/06/30 15:19:13 wolf31o2 Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org driver for cirrus cards"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~sh x86 ~x86-fbsd"
RDEPEND="x11-base/xorg-server"
DEPEND="${RDEPEND}
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/videoproto
	x11-proto/xextproto
	x11-proto/xproto"
