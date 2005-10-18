# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/knotes/knotes-3.4.1.ebuild,v 1.9 2005/10/18 19:02:27 agriffis Exp $

KMNAME=kdepim
MAXKDEVER=3.4.2
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE Notes"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
IUSE=""
DEPEND="$(deprange $PV 3.4.2 kde-base/libkcal)
$(deprange $PV 3.4.2 kde-base/libkdepim)
$(deprange $PV 3.4.2 kde-base/kontact)"
KMCOPYLIB="
	libkcal libkcal
	libkdepim libkdepim
	libkpinterfaces kontact/interfaces"
KMEXTRACTONLY="
	libkcal/
	libkdepim/
	kontact/interfaces"
KMEXTRA="kontact/plugins/knotes" # We add here the kontact's plugin instead of compiling it with kontact because it needs a lot of this programs deps.