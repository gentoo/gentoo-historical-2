# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdepasswd/kdepasswd-3.5.0.ebuild,v 1.6 2006/03/27 23:37:15 agriffis Exp $

KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE GUI for passwd"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""


DEPEND="
$(deprange $PV $MAXKDEVER kde-base/libkonq)"

KMCOPYLIB="libkonq libkonq"
KMNODOCS=true
