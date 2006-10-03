# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeadmin-meta/kdeadmin-meta-3.5.5.ebuild,v 1.2 2006/10/03 09:59:46 flameeyes Exp $
MAXKDEVER=$PV

inherit kde-functions
DESCRIPTION="kdeadmin - merge this to pull in all kdeadmin-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="3.5"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="$(deprange $PV $MAXKDEVER kde-base/kcron)
	$(deprange $PV $MAXKDEVER kde-base/kdeadmin-kfile-plugins)
	$(deprange $PV $MAXKDEVER kde-base/kuser)
	x86? ( $(deprange $PV $MAXKDEVER kde-base/lilo-config) )
	amd64? ( $(deprange $PV $MAXKDEVER kde-base/lilo-config) )
	$(deprange 3.5.0 $MAXKDEVER kde-base/secpolicy)"

# NOTE: KPackage, KSysv are useless on a normal gentoo system and so aren't included
# in the above list. KDat is broken and unmaintained. However, packages do nominally
# exist for them.

