# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/dcoprss/dcoprss-3.4.0.ebuild,v 1.1 2005/03/13 21:18:58 danarmak Exp $

KMNAME=kdenetwork
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE: RSS server and client for DCOP"
KEYWORDS="~x86 ~amd64"
IUSE=""
DEPEND="$(deprange $PV $MAXKDEVER kde-base/librss)"
OLDDEPEND="~kde-base/librss-$PV"

KMCOPYLIB="librss librss"
KMEXTRACTONLY="librss"
