# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kcminit/kcminit-4.3.0.ebuild,v 1.1 2009/08/04 00:00:34 wired Exp $

EAPI="2"

KMNAME="kdebase-workspace"
inherit kde4-meta

DESCRIPTION="KCMInit - runs startups initialization for Control Modules."
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="debug"

DEPEND="
	>=kde-base/ksplash-${PV}:${SLOT}[kdeprefix=]
"
RDEPEND="${DEPEND}"
