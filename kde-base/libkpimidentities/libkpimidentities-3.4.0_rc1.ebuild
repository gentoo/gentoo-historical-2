# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/libkpimidentities/libkpimidentities-3.4.0_rc1.ebuild,v 1.2 2005/03/03 11:52:45 cryos Exp $

KMNAME=kdepim
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE PIM identities library"
KEYWORDS="~x86 ~amd64"
IUSE=""
DEPEND="$(deprange $PV $MAXKDEVER kde-base/certmanager)
$(deprange $PV $MAXKDEVER kde-base/libkdepim)"
OLDDEPEND="~kde-base/certmanager-$PV ~kde-base/libkdepim-$PV"

KMCOPYLIB="
	libkleopatra certmanager/lib/
	libkdepim libkdepim/"
KMEXTRACTONLY="
	libkdepim/
	certmanager/"
KMCOMPILEONLY="
	libemailfunctions/"
