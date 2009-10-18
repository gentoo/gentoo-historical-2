# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/nsplugins/nsplugins-4.3.1.ebuild,v 1.3 2009/10/18 16:53:13 maekke Exp $

EAPI="2"

KMNAME="kdebase-apps"
inherit kde4-meta

DESCRIPTION="Netscape plugins support for Konqueror."
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 x86"
IUSE="debug"

DEPEND="
	x11-libs/libXt
"
RDEPEND="${DEPEND}
	>=kde-base/konqueror-${PV}:${SLOT}[kdeprefix=]
"

KMEXTRACTONLY="
	konqueror/settings/
"
