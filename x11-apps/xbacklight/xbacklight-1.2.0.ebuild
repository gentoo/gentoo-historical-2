# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xbacklight/xbacklight-1.2.0.ebuild,v 1.3 2012/11/18 12:07:57 ago Exp $

EAPI=3

inherit xorg-2

DESCRIPTION="Sets backlight level using the RandR 1.2 BACKLIGHT output property"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libxcb
	x11-libs/xcb-util"
DEPEND="${RDEPEND}"
