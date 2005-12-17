# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-input-dynapro/xf86-input-dynapro-1.0.0.4.ebuild,v 1.1 2005/12/17 23:53:15 joshuabaergen Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org driver for dynapro input devices"
KEYWORDS="~x86"
RDEPEND="x11-base/xorg-server"
DEPEND="${RDEPEND}
	x11-proto/xproto"
