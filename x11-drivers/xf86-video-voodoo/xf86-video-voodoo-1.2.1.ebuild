# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-voodoo/xf86-video-voodoo-1.2.1.ebuild,v 1.2 2009/03/13 16:09:32 armin76 Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"
XDPVER=4

inherit x-modular

DESCRIPTION="Voodoo video driver"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86 ~x86-fbsd"
RDEPEND=">=x11-base/xorg-server-1.0.99"
DEPEND="${RDEPEND}
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/xextproto
	x11-proto/xf86dgaproto
	x11-proto/xproto"
