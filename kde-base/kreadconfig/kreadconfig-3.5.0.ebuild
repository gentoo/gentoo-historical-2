# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kreadconfig/kreadconfig-3.5.0.ebuild,v 1.3 2005/12/04 01:42:27 kloeri Exp $

KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE: Read KConfig entries - for use in shell scripts"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE=""


