# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kfind/kfind-3.4.1.ebuild,v 1.2 2005/05/26 17:14:27 danarmak Exp $

KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE file find utility"
KEYWORDS="~x86 ~amd64 ~ppc64 ~ppc ~sparc"
IUSE=""

DEPEND="$(deprange $PV $MAXKDEVER kde-base/libkonq)"
OLDDEPEND="~kde-base/libkonq-$PV"

KMCOPYLIB="libkonq libkonq"
