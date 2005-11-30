# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ksysguard/ksysguard-3.4.1.ebuild,v 1.1.1.1 2005/11/30 10:12:48 chriswhite Exp $

KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE System Guard"
KEYWORDS="~x86 ~amd64 ~ppc64 ~ppc ~sparc"
IUSE="lm_sensors"
DEPEND="lm_sensors? ( sys-apps/lm_sensors )"

