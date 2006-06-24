# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/kpowersave/kpowersave-0.6.1.ebuild,v 1.3 2006/06/24 16:37:01 flameeyes Exp $

inherit kde

DESCRIPTION="KDE front-end to powersave daemon"
HOMEPAGE="http://powersave.sf.net/"
SRC_URI="mirror://sourceforge/powersave/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=sys-apps/hal-0.5.4
	>=sys-apps/dbus-0.33
	>=sys-power/powersave-0.11.5
	kde-base/unsermake"

pkg_setup() {
	if ! built_with_use sys-apps/dbus qt3; then
		eerror "dbus is missing qt3 support. Please add"
		eerror "'qt3' to your USE flags, and re-emerge sys-apps/dbus."
		die "dbus needs qt3 support"
	fi

	set-kdedir
	UNSERMAKE="/usr/kde/unsermake/unsermake"
}
