# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-voodoo/xf86-video-voodoo-1.0.0.5.ebuild,v 1.6 2006/03/03 02:09:51 vapier Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org driver for voodoo cards"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~sh ~x86"
RDEPEND="x11-base/xorg-server"
DEPEND="${RDEPEND}
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/xextproto
	x11-proto/xf86dgaproto
	x11-proto/xproto"
