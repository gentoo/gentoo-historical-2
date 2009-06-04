# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/drkonqi/drkonqi-4.2.4.ebuild,v 1.1 2009/06/04 11:08:37 alexxy Exp $

EAPI="2"

KMNAME="kdebase-runtime"
inherit kde4-meta

DESCRIPTION="KDE crash handler, gives the user feedback if a program crashed"
IUSE="debug"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

RDEPEND="
	sys-devel/gdb
"
