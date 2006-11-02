# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-vmware/xf86-video-vmware-10.14.0.ebuild,v 1.1 2006/11/02 23:56:51 joshuabaergen Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"
XDPVER=2

inherit x-modular

DESCRIPTION="VMware SVGA video driver"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
RDEPEND=">=x11-base/xorg-server-1.0.99.901"
DEPEND="${RDEPEND}
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/xextproto
	x11-proto/xineramaproto
	x11-proto/xproto"
