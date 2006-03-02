# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-rendition/xf86-video-rendition-4.0.1.3.ebuild,v 1.3 2006/03/02 02:22:20 vapier Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org driver for rendition cards"
KEYWORDS="~amd64 ~ia64 ~x86"
RDEPEND="x11-base/xorg-server"
DEPEND="${RDEPEND}
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/xextproto
	x11-proto/xproto"
