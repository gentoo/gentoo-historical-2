# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kontact/kontact-3.4.3.ebuild,v 1.8 2006/03/26 16:31:02 agriffis Exp $

KMNAME=kdepim
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE personal information manager"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE=""
OLDDEPEND="~kde-base/libkdepim-$PV"
DEPEND="
$(deprange $PV $MAXKDEVER kde-base/libkdepim)
$(deprange $PV $MAXKDEVER kde-base/libkpimidentities)"

KMCOPYLIB="libkdepim libkdepim/
	libkpimidentities.la libkpimidentities/"
KMEXTRACTONLY="libkdepim/
	libkpimidentities/
	kontact/plugins/"
KMEXTRA="
	kontact/plugins/newsticker/
	kontact/plugins/summary/
	kontact/plugins/weather/"
# We remove some plugins that are related to external kdepim's programs, because they needs also libs from korganizer, kpilot etc... so to emerge kontact we'll need also ALL the other programs, it's better to emerge the kontact's plugins in the ebuild of its program

