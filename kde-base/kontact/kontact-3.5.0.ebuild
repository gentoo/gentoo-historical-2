# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kontact/kontact-3.5.0.ebuild,v 1.1 2005/11/22 22:14:10 danarmak Exp $

KMNAME=kdepim
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE personal information manager"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

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

