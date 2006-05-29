# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kde-meta/kde-meta-3.5.2.ebuild,v 1.6 2006/05/29 22:19:41 weeve Exp $
MAXKDEVER=$PV

inherit kde-functions
DESCRIPTION="kde - merge this to pull in all kde packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="3.5"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ppc64 sparc x86"
IUSE="accessibility"

RDEPEND="~kde-base/kdelibs-${PV}
$(deprange $PV $MAXKDEVER kde-base/kdeaddons-meta)
$(deprange $PV $MAXKDEVER kde-base/kdeadmin-meta)
$(deprange $PV $MAXKDEVER kde-base/kdebase-meta)
$(deprange $PV $MAXKDEVER kde-base/kdeedu-meta)
$(deprange $PV $MAXKDEVER kde-base/kdegames-meta)
$(deprange $PV $MAXKDEVER kde-base/kdegraphics-meta)
$(deprange $PV $MAXKDEVER kde-base/kdemultimedia-meta)
$(deprange $PV $MAXKDEVER kde-base/kdenetwork-meta)
$(deprange $PV $MAXKDEVER kde-base/kdepim-meta)
$(deprange $PV $MAXKDEVER kde-base/kdetoys-meta)
$(deprange $PV $MAXKDEVER kde-base/kdeutils-meta)
$(deprange $PV $MAXKDEVER kde-base/kdeartwork-meta)
$(deprange $PV $MAXKDEVER kde-base/kdewebdev-meta)
accessibility? ( $(deprange $PV $MAXKDEVER kde-base/kdeaccessibility-meta) )"
