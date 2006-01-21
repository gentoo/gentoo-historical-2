# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-input-vmmouse/xf86-input-vmmouse-12.3.1.0.ebuild,v 1.2 2006/01/21 03:32:32 joshuabaergen Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

SRC_URI="http://xorg.freedesktop.org/releases/individual/driver/${PN}/${P}.tar.bz2
	${SRC_URI}"
DESCRIPTION="X.Org driver for the VMWare virtual mouse"
KEYWORDS="~x86"
RDEPEND=">=x11-base/xorg-server-0.99.3"
DEPEND="${RDEPEND}
	x11-proto/inputproto
	x11-proto/randrproto
	x11-proto/xproto"
