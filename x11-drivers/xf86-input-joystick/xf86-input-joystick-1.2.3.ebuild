# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-input-joystick/xf86-input-joystick-1.2.3.ebuild,v 1.2 2007/11/07 21:30:50 dberkholz Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"
XDPVER=-1

inherit x-modular

DESCRIPTION="X.Org driver for joystick input devices"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
RDEPEND=">=x11-base/xorg-server-1.4"
DEPEND="${RDEPEND}
	x11-proto/inputproto
	x11-proto/randrproto
	x11-proto/xproto"
