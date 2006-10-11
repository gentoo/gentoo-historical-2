# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-input-tek4957/xf86-input-tek4957-1.0.0.5.ebuild,v 1.16 2006/10/11 00:27:00 dberkholz Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="Tektronix 4957 input driver"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ~ppc ppc64 ~sh ~sparc x86 ~x86-fbsd"
RDEPEND="x11-base/xorg-server"
DEPEND="${RDEPEND}
	x11-proto/inputproto
	x11-proto/randrproto
	x11-proto/xproto"
