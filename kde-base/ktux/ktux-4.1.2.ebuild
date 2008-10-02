# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ktux/ktux-4.1.2.ebuild,v 1.1 2008/10/02 10:26:45 jmbsvicetto Exp $

EAPI="2"

KMNAME=kdetoys
inherit kde4-meta

DESCRIPTION="KDE: screensaver featuring the Space-Faring Tux"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND=">=app-misc/strigi-0.5.7
	>=kde-base/kscreensaver-${PV}:${SLOT}"
RDEPEND="${DEPEND}"
