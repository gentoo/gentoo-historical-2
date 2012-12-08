# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-dummy/xf86-video-dummy-0.3.6.ebuild,v 1.6 2012/12/08 17:09:21 ago Exp $

EAPI=4
inherit xorg-2

DESCRIPTION="X.Org driver for dummy cards"

KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ppc ppc64 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux"
IUSE="dga"

RDEPEND=">=x11-base/xorg-server-1.0.99"
DEPEND="${RDEPEND}
	dga? (
		x11-proto/xf86dgaproto
	)"

pkg_setup() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable dga)
	)
	xorg-2_pkg_setup
}
