# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/noatun-luckytag/noatun-luckytag-3.4.0_beta2.ebuild,v 1.1 2005/02/05 11:39:27 danarmak Exp $
KMNAME=kdeaddons
KMNOMODULE=true
KMEXTRA="noatun-plugins/luckytag"
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="noatun plugin that guesses tag values (author, title, ...) from filenames"
KEYWORDS="~x86"
IUSE=""
DEPEND="$(deprange $PV $MAXKDEVER kde-base/noatun)"
OLDDEPEND="~kde-base/noatun-$PV"


