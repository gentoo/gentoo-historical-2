# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-input-keyboard/xf86-input-keyboard-1.2.0.ebuild,v 1.2 2007/06/24 18:20:41 peper Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="Keyboard input driver"
KEYWORDS=""
RDEPEND=">=x11-base/xorg-server-1.2.99"
DEPEND="${RDEPEND}
	x11-proto/inputproto
	x11-proto/kbproto
	x11-proto/randrproto
	x11-proto/xproto"
