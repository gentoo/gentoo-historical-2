# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kspy/kspy-3.5.8.ebuild,v 1.6 2008/02/09 12:24:51 armin76 Exp $

KMNAME=kdesdk
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="kspy - an utility intended to help developers examine the internal state of a Qt/KDE application"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="kdehiddenvisibility"

RESTRICT="test"
