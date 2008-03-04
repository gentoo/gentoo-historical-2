# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/akregator/akregator-3.5.8.ebuild,v 1.7 2008/03/04 06:22:37 jer Exp $

KMNAME=kdepim
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"

inherit kde-meta eutils

SRC_URI="${SRC_URI}
	mirror://gentoo/kdepim-3.5-patchset-04.tar.bz2"

DESCRIPTION="KDE news feed aggregator."
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""
DEPEND="$(deprange $PV $MAXKDEVER kde-base/libkdepim)
	$(deprange $PV $MAXKDEVER kde-base/kontact)
	!net-www/akregator"

RDEPEND="${DEPEND}"

KMCOPYLIB="libkdepim libkdepim
	libkpinterfaces kontact/interfaces"
KMEXTRACTONLY="libkdepim
	kontact/interfaces"
KMEXTRA="kontact/plugins/akregator"
