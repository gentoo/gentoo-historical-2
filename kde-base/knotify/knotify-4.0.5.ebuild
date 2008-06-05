# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/knotify/knotify-4.0.5.ebuild,v 1.1 2008/06/05 22:05:48 keytoaster Exp $

EAPI="1"

KMNAME=kdebase-runtime
inherit kde4-meta

DESCRIPTION="The KDE notification daemon."
IUSE="debug"
KEYWORDS="~amd64 ~x86"

DEPEND=">=kde-base/phonon-${PV}:${SLOT}"
RDEPEND="${DEPEND}"
