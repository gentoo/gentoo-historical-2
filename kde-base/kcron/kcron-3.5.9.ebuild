# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kcron/kcron-3.5.9.ebuild,v 1.1 2008/02/20 22:40:40 philantrop Exp $
KMNAME=kdeadmin
EAPI="1"
inherit kde-meta

DESCRIPTION="KDE Task Scheduler"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="kdehiddenvisibility"

DEPEND=""
RDEPEND="virtual/cron"
