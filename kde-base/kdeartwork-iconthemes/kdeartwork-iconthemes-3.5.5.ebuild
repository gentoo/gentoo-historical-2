# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeartwork-iconthemes/kdeartwork-iconthemes-3.5.5.ebuild,v 1.7 2006/11/28 01:17:57 flameeyes Exp $

ARTS_REQUIRED="never"
RESTRICT="binchecks strip"

KMMODULE=IconThemes
KMNAME=kdeartwork
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="Icon themes for kde"
KEYWORDS="~alpha amd64 ~ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""
DEPEND=""
