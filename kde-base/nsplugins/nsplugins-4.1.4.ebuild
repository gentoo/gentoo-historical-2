# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/nsplugins/nsplugins-4.1.4.ebuild,v 1.1 2009/01/13 23:26:59 alexxy Exp $

EAPI="2"

KMNAME=kdebase
KMMODULE=apps/${PN}
inherit kde4-meta

DESCRIPTION="Netscape plugins support for Konqueror."
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug"

DEPEND=">=kde-base/konqueror-${PV}:${SLOT}
	x11-libs/libXt"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="apps/konqueror/settings/"
