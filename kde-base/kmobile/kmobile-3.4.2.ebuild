# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kmobile/kmobile-3.4.2.ebuild,v 1.1.1.1 2005/11/30 10:13:44 chriswhite Exp $

KMNAME=kdepim
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE mobile devices manager"
KEYWORDS=" ~x86 ~amd64 ~ppc ~sparc"
IUSE=""
DEPEND="app-mobilephone/gnokii"
