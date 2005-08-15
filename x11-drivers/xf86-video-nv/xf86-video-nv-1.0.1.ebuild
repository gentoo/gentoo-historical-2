# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-nv/xf86-video-nv-1.0.1.ebuild,v 1.2 2005/08/15 20:17:47 herbs Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org driver for nv cards"
KEYWORDS="~amd64 ~x86"
RDEPEND="x11-base/xorg-server"
DEPEND="${RDEPEND}
	x11-proto/xproto"
