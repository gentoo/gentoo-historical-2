# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-cyrix/xf86-video-cyrix-1.0.0.5.ebuild,v 1.5 2006/04/16 14:08:49 flameeyes Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org driver for cyrix cards"
KEYWORDS="~amd64 ~ia64 ~sh ~x86 ~x86-fbsd"
RDEPEND="x11-base/xorg-server"
DEPEND="${RDEPEND}
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/xextproto
	x11-proto/xf86dgaproto
	x11-proto/xproto"
