# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kcron/kcron-4.1.4.ebuild,v 1.1 2009/01/13 21:26:56 alexxy Exp $

EAPI="2"

KMNAME=kdeadmin
inherit kde4-meta

DESCRIPTION="KDE Task Scheduler"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug htmlhandbook"

RDEPEND="virtual/cron
	>=kde-base/knotify-${PV}:${SLOT}"
