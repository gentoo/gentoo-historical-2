# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-v4l/xf86-video-v4l-0.0.1.5.ebuild,v 1.2 2006/02/02 19:20:34 metalgod Exp $

# Must be before x-modular eclass is inherited
# SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org driver for v4l devices"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="x11-base/xorg-server"
DEPEND="${RDEPEND}
	x11-proto/randrproto
	x11-proto/videoproto
	x11-proto/xproto"
