# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdf/kdf-3.5.0.ebuild,v 1.1.1.1 2005/11/30 10:14:07 chriswhite Exp $

KMNAME=kdeutils
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE free disk space utility"
KEYWORDS="~amd64 ~x86"
IUSE=""