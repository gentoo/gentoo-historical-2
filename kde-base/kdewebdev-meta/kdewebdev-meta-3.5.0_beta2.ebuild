# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdewebdev-meta/kdewebdev-meta-3.5.0_beta2.ebuild,v 1.2 2005/10/22 06:54:14 halcy0n Exp $
MAXKDEVER=$PV

inherit kde-functions
DESCRIPTION="kdewebdev - merge this to pull in all kdewebdev-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="3.5"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
$(deprange $PV $MAXKDEVER kde-base/kfilereplace)
$(deprange 3.5_beta1 $MAXKDEVER kde-base/kimagemapeditor)
$(deprange $PV $MAXKDEVER kde-base/klinkstatus)
$(deprange $PV $MAXKDEVER kde-base/kommander)
$(deprange $PV $MAXKDEVER kde-base/kxsldbg)
$(deprange $PV $MAXKDEVER kde-base/quanta)
"
