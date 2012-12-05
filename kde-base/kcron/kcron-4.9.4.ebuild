# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kcron/kcron-4.9.4.ebuild,v 1.1 2012/12/05 16:58:16 alexxy Exp $

EAPI=4

KDE_HANDBOOK="optional"
KMNAME="kdeadmin"
KDE_SCM="svn"
inherit kde4-meta

DESCRIPTION="KDE Task Scheduler"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="!prefix? ( virtual/cron )"
