# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ksvg/ksvg-3.4.1.ebuild,v 1.1 2005/05/25 21:23:11 danarmak Exp $

KMNAME=kdegraphics
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="SVG viewer library and embeddable kpart"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="media-libs/libart_lgpl
	media-libs/lcms
	dev-libs/fribidi"
