# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kitchensync/kitchensync-3.4.1.ebuild,v 1.5 2005/07/01 22:34:45 pylon Exp $

KMNAME=kdepim
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="Synchronize Data with KDE"
KEYWORDS="amd64 ppc ppc64 ~sparc x86"
IUSE=""
OLDDEPEND="~kde-base/libkdepim-$PV
	~kde-base/libkcal-$PV"
DEPEND="$(deprange $PV $MAXKDEVER kde-base/kontact)
$(deprange $PV $MAXKDEVER kde-base/libkcal)"

KMCOPYLIB="
	libkcal libkcal
	libkdepim libkdepim
	libkpinterfaces kontact/interfaces"
KMEXTRACTONLY="
	libkcal/
	libkdepim/
	libkdenetwork/
	kontact/interfaces"

# Disabled by default in kontact/plugins/Makefile.am, so check before enabling - 3.4.0_beta1 -- danarmak
# KMEXTRA="kontact/plugins/kitchensync"
KMEXTRA="kontact/plugins/multisynk"
