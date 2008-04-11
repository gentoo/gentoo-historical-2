# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-radeonhd/xf86-video-radeonhd-1.2.0.ebuild,v 1.1 2008/04/11 13:54:41 je_fro Exp $

XDPVER=-1
inherit x-modular

DESCRIPTION="Experimental Radeon HD video driver."
HOMEPAGE="http://wiki.x.org/wiki/radeonhd"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.3.0"

DEPEND="${RDEPEND}
	x11-proto/xextproto
	x11-proto/xproto"
