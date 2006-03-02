# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-input-elographics/xf86-input-elographics-1.0.0.5.ebuild,v 1.7 2006/03/02 06:05:11 vapier Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org driver for elographics input devices"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~x86"
RDEPEND="x11-base/xorg-server"
DEPEND="${RDEPEND}
	x11-proto/inputproto
	x11-proto/randrproto
	x11-proto/xproto"
