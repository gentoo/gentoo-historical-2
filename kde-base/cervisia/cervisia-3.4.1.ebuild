# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/cervisia/cervisia-3.4.1.ebuild,v 1.4 2005/07/01 12:50:24 corsair Exp $

KMNAME=kdesdk
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="Cervisia - A KDE CVS frontend"
KEYWORDS="amd64 ~ppc ppc64 ~sparc x86"
IUSE=""

RDEPEND="$DEPEND
	dev-util/cvs"