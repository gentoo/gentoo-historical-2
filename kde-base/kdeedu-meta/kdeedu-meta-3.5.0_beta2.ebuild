# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeedu-meta/kdeedu-meta-3.5.0_beta2.ebuild,v 1.1 2005/10/14 18:41:51 danarmak Exp $
MAXKDEVER=$PV

inherit kde-functions
DESCRIPTION="kdeedu - merge this to pull in all kdeedu-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="3.5"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
$(deprange $PV $MAXKDEVER kde-base/blinken)
$(deprange $PV $MAXKDEVER kde-base/kanagram)
$(deprange $PV $MAXKDEVER kde-base/kalzium)
$(deprange $PV $MAXKDEVER kde-base/kgeography)
$(deprange $PV $MAXKDEVER kde-base/khangman)
$(deprange $PV $MAXKDEVER kde-base/kig)
$(deprange 3.5_beta1 $MAXKDEVER kde-base/kpercentage)
$(deprange $PV $MAXKDEVER kde-base/kiten)
$(deprange $PV $MAXKDEVER kde-base/kvoctrain)
$(deprange $PV $MAXKDEVER kde-base/kturtle)
$(deprange 3.5_beta1 $MAXKDEVER kde-base/kverbos)
$(deprange 3.5_beta1 $MAXKDEVER kde-base/kdeedu-applnk)
$(deprange 3.5_beta1 $MAXKDEVER kde-base/kbruch)
$(deprange $PV $MAXKDEVER kde-base/keduca)
$(deprange $PV $MAXKDEVER kde-base/klatin)
$(deprange $PV $MAXKDEVER kde-base/kmplot)
$(deprange $PV $MAXKDEVER kde-base/kstars)
$(deprange $PV $MAXKDEVER kde-base/ktouch)
$(deprange $PV $MAXKDEVER kde-base/klettres)
$(deprange 3.5_beta1 $MAXKDEVER kde-base/kmathtool)
$(deprange $PV $MAXKDEVER kde-base/kwordquiz)
"
