# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/konqueror/konqueror-3.4.3.ebuild,v 1.5 2005/11/24 22:41:42 cryos Exp $

KMNAME=kdebase
# Note: we need >=kdelibs-3.3.2-r1, but we don't want 3.3.3!
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE: Web browser, file manager, ..."
KEYWORDS="~alpha amd64 ~ppc ppc64 sparc ~x86"
IUSE="java"

OLDDEPEND="~kde-base/libkonq-3.3.1"
DEPEND="
$(deprange $PV $MAXKDEVER kde-base/libkonq)"

RDEPEND="${DEPEND}
$(deprange $PV $MAXKDEVER kde-base/kcontrol)
$(deprange $PV $MAXKDEVER kde-base/kdebase-kioslaves)
java? ( >=virtual/jre-1.4 )"

KMCOPYLIB="libkonq libkonq"
KMEXTRACTONLY=kdesktop/KDesktopIface.h
