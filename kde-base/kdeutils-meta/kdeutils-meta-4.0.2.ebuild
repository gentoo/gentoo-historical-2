# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeutils-meta/kdeutils-meta-4.0.2.ebuild,v 1.1 2008/03/10 23:36:34 philantrop Exp $

EAPI="1"

inherit kde4-functions

DESCRIPTION="KDE utilities - merge this to pull in all kdeutils-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="kde-4"
KEYWORDS="~amd64 ~x86"
# add lirc when kdelirc gets ready
IUSE="crypt"

RDEPEND="
	>=kde-base/ark-${PV}:${SLOT}
	>=kde-base/kcalc-${PV}:${SLOT}
	>=kde-base/kcharselect-${PV}:${SLOT}
	>=kde-base/kdf-${PV}:${SLOT}
	>=kde-base/kfloppy-${PV}:${SLOT}
	crypt? ( >=kde-base/kgpg-${PV}:${SLOT} )
	>=kde-base/kjots-${PV}:${SLOT}
	>=kde-base/kmilo-${PV}:${SLOT}
	>=kde-base/kdessh-${PV}:${SLOT}
	>=kde-base/ktimer-${PV}:${SLOT}
	>=kde-base/kwallet-${PV}:${SLOT}
	>=kde-base/superkaramba-${PV}:${SLOT}
	>=kde-base/sweeper-${PV}:${SLOT}
"
## the following packages are currently missing in kde 4

#>=kde-base/ksim-${PV}:${SLOT}
#>=kde-base/klaptopdaemon-${PV}:${SLOT}
#lirc? ( >=kde-base/kdelirc-${PV}:${SLOT} )
