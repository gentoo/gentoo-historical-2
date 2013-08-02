# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kcron/kcron-4.10.5.ebuild,v 1.5 2013/08/02 14:29:58 ago Exp $

EAPI=5

if [[ $PV != *9999 ]]; then
	KMNAME="kdeadmin"
	KDE_ECLASS=meta
else
	KDE_ECLASS=base
fi

KDE_HANDBOOK="optional"
inherit kde4-${KDE_ECLASS}

DESCRIPTION="KDE Task Scheduler"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="!prefix? ( virtual/cron )"
