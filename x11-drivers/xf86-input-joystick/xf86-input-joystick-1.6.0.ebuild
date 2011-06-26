# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-input-joystick/xf86-input-joystick-1.6.0.ebuild,v 1.2 2011/06/26 21:01:44 maekke Exp $

EAPI=4
inherit xorg-2

DESCRIPTION="X.Org driver for joystick input devices"

KEYWORDS="~alpha ~amd64 arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.10"
DEPEND="${RDEPEND}
	x11-proto/inputproto
	x11-proto/kbproto"
