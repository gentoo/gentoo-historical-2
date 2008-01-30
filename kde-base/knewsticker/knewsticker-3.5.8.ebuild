# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/knewsticker/knewsticker-3.5.8.ebuild,v 1.4 2008/01/30 10:09:56 opfer Exp $

KMNAME=kdenetwork
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="kicker plugin: rss news ticker"
KEYWORDS="alpha amd64 ia64 ~ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE="kdehiddenvisibility"

DEPEND="$(deprange 3.5.6 $MAXKDEVER kde-base/librss)"

RDEPEND="${DEPEND}"

KMCOPYLIB="librss librss"
KMEXTRACTONLY="librss"
