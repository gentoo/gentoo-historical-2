# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/activitymanager/activitymanager-4.5.1.ebuild,v 1.3 2010/09/05 23:07:57 tampakrap Exp $

EAPI="3"

KMNAME="kdebase-runtime"
inherit kde4-meta

DESCRIPTION="Activity manager"
KEYWORDS=""
IUSE="debug"

KMEXTRACTONLY="
	nepomuk/services/activities/org.kde.nepomuk.ActivitiesService.xml
"
