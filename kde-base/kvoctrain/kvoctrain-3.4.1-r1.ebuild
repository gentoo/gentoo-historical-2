# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kvoctrain/kvoctrain-3.4.1-r1.ebuild,v 1.4 2005/08/16 02:53:55 weeve Exp $
KMNAME=kdeedu
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="KDE Educational: vocabulary trainer"
KEYWORDS="amd64 ~ppc ppc64 sparc x86"
IUSE=""
DEPEND=""

PATCHES="${FILESDIR}/post-3.4.2-kdeedu.diff"