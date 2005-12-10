# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/certmanager/certmanager-3.4.3.ebuild,v 1.6 2005/12/10 05:16:12 chriswhite Exp $

KMNAME=kdepim
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE certificate manager gui"
KEYWORDS="~alpha amd64 ppc ppc64 sparc x86"
IUSE=""
OLDDEPEND="~kde-base/libkdenetwork-$PV"
DEPEND="
$(deprange 3.4.1 $MAXKDEVER kde-base/libkpgp)
$(deprange 3.4.1 $MAXKDEVER kde-base/libkdenetwork)"

KMCOPYLIB="libqgpgme libkdenetwork/qgpgme/"
KMEXTRACTONLY="libkdenetwork/
	libkpgp/
	libkdepim/"

KMEXTRA="
	doc/kleopatra
	doc/kwatchgnupg"
