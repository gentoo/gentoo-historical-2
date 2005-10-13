# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeedu-meta/kdeedu-meta-3.4.1.ebuild,v 1.7 2005/10/13 12:42:43 greg_g Exp $
MAXKDEVER=$PV

inherit kde-functions
DESCRIPTION="kdeedu - merge this to pull in all kdeedu-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="3.4"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND="
$(deprange $PV $MAXKDEVER kde-base/kig)
$(deprange $PV $MAXKDEVER kde-base/kalzium)
$(deprange $PV $MAXKDEVER kde-base/khangman)
$(deprange $PV $MAXKDEVER kde-base/kpercentage)
$(deprange $PV $MAXKDEVER kde-base/kiten)
$(deprange $PV $MAXKDEVER kde-base/kvoctrain)
$(deprange $PV $MAXKDEVER kde-base/kturtle)
$(deprange $PV $MAXKDEVER kde-base/kverbos)
$(deprange $PV $MAXKDEVER kde-base/kdeedu-applnk)
$(deprange $PV $MAXKDEVER kde-base/kbruch)
$(deprange $PV $MAXKDEVER kde-base/keduca)
$(deprange $PV $MAXKDEVER kde-base/kmessedwords)
$(deprange $PV $MAXKDEVER kde-base/klatin)
$(deprange $PV $MAXKDEVER kde-base/kmplot)
$(deprange $PV $MAXKDEVER kde-base/kstars)
$(deprange $PV $MAXKDEVER kde-base/ktouch)
$(deprange $PV $MAXKDEVER kde-base/klettres)
$(deprange $PV $MAXKDEVER kde-base/kmathtool)
$(deprange $PV $MAXKDEVER kde-base/kwordquiz)
"
