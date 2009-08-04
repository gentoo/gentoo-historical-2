# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeutils-meta/kdeutils-meta-4.3.0.ebuild,v 1.2 2009/08/04 06:33:06 wired Exp $

EAPI="2"

DESCRIPTION="kdeutils - merge this to pull in all kdeutils-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="4.3"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="floppy kdeprefix lirc"

RDEPEND="
	>=kde-base/ark-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kcalc-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kcharselect-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kdessh-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kdf-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kgpg-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/ktimer-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kwallet-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/superkaramba-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/sweeper-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/okteta-${PV}:${SLOT}[kdeprefix=]
	floppy? ( >=kde-base/kfloppy-${PV}:${SLOT}[kdeprefix=] )
	lirc? ( >=kde-base/kdelirc-${PV}:${SLOT}[kdeprefix=] )
"
