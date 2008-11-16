# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/soliduiserver/soliduiserver-4.1.3.ebuild,v 1.2 2008/11/16 08:27:24 vapier Exp $

EAPI="2"

KMNAME=kdebase-runtime
inherit kde4-meta

DESCRIPTION="KDE4: Soliduiserver"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug"

DEPEND=">=kde-base/solid-${PV}:${SLOT}"
RDEPEND="${DEPEND}"
