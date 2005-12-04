# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-v4l/xf86-video-v4l-0.0.1.3.ebuild,v 1.1 2005/12/04 23:20:21 joshuabaergen Exp $

# Must be before x-modular eclass is inherited
# SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org driver for v4l devices"
KEYWORDS="~x86"
IUSE=""
RDEPEND="x11-base/xorg-server"
DEPEND="${RDEPEND}
	x11-proto/xproto"

