# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/drkonqi/drkonqi-4.3.3.ebuild,v 1.5 2009/12/10 13:59:47 fauli Exp $

EAPI="2"

KMNAME="kdebase-runtime"
inherit kde4-meta

DESCRIPTION="KDE crash handler, gives the user feedback if a program crashed"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ppc64 ~sparc x86"
IUSE="debug"

add_blocker drkonqi2

pkg_postinst() {
	kde4-meta_pkg_postinst
	elog "For more usability consider installing folowing packages:"
	elog "    sys-devel/gdb - Easier debugging support"
}
