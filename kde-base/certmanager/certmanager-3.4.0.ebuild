# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/certmanager/certmanager-3.4.0.ebuild,v 1.1 2005/03/13 21:18:58 danarmak Exp $

KMNAME=kdepim
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE certificate manager gui"
KEYWORDS="~x86 ~amd64"
IUSE=""
OLDDEPEND="~kde-base/libkdenetwork-$PV"
DEPEND="
$(deprange $PV $MAXKDEVER kde-base/libkpgp)
$(deprange $PV $MAXKDEVER kde-base/libkdenetwork)"

KMCOPYLIB="libqgpgme libkdenetwork/qgpgme/"
KMEXTRACTONLY="libkdenetwork/
	libkpgp/
	libkdepim/"

KMEXTRA="
	doc/kleopatra
	doc/kwatchgnupg"