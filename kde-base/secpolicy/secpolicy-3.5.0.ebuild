# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/secpolicy/secpolicy-3.5.0.ebuild,v 1.17 2006/07/25 09:36:29 flameeyes Exp $
KMNAME=kdeadmin
MAXKDEVER=3.5.4
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="KDE: Display PAM security policies"
KEYWORDS="alpha amd64 ~ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""
DEPEND=""

# NOTE TODO some dep is missing here - check on empty install