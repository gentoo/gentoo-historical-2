# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kpackage/kpackage-3.5.0.ebuild,v 1.1 2005/11/22 22:14:10 danarmak Exp $
KMNAME=kdeadmin
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="KDE package manager (deb, rpm etc support; rudimentary ebuild support)"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=""

