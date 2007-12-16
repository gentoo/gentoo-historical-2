# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-input-evdev/xf86-input-evdev-1.1.5-r2.ebuild,v 1.5 2007/12/16 15:31:07 nixnut Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"
XDPVER=4

inherit x-modular

DESCRIPTION="Generic Linux input driver"

KEYWORDS="alpha amd64 ~arm ~hppa ia64 ~mips ppc ~ppc64 ~sh sparc ~x86"

RDEPEND="x11-base/xorg-server"
DEPEND="${RDEPEND}
	|| ( >=sys-kernel/linux-headers-2.6 >=sys-kernel/mips-headers-2.6 )
	>=x11-proto/inputproto-1.4
	x11-proto/randrproto
	x11-proto/xproto"

PATCHES="${FILESDIR}/1.1.5-fix_compatibility.patch
	${FILESDIR}/1.1.5-zaphod-mouse-fix.patch"
