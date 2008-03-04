# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/korn/korn-3.5.8.ebuild,v 1.7 2008/03/04 06:34:03 jer Exp $

KMNAME=kdepim
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE mailbox checker"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""
DEPEND="$(deprange 3.5.7 $MAXKDEVER kde-base/mimelib)
$(deprange $PV $MAXKDEVER kde-base/libkmime)"

RDEPEND="${DEPEND}
	$(deprange-dual $PV $MAXKDEVER kde-base/kdebase-kioslaves)
	$(deprange $PV $MAXKDEVER kde-base/kdepim-kioslaves)"
KMCOPYLIB="libmimelib mimelib
	libkmime libkmime"
# libkcal is installed because a lot of headers are needed, but it don't have to be compiled
KMEXTRACTONLY="
	mimelib/
	libkmime/
	libkdenetwork/"
