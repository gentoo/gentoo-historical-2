# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdenetwork-meta/kdenetwork-meta-3.5.10.ebuild,v 1.6 2009/07/08 13:49:06 alexxy Exp $

EAPI="1"
inherit kde-functions
DESCRIPTION="kdenetwork - merge this to pull in all kdenetwork-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="3.5"
KEYWORDS="~alpha amd64 hppa ~ia64 ~mips ppc ppc64 ~sparc x86 ~x86-fbsd"
IUSE="wifi"

RDEPEND=">=kde-base/dcoprss-${PV}:${SLOT}
	>=kde-base/kdenetwork-filesharing-${PV}:${SLOT}
	>=kde-base/kdict-${PV}:${SLOT}
	>=kde-base/kget-${PV}:${SLOT}
	>=kde-base/knewsticker-${PV}:${SLOT}
	>=kde-base/kopete-${PV}:${SLOT}
	>=kde-base/kpf-${PV}:${SLOT}
	>=kde-base/kppp-${PV}:${SLOT}
	>=kde-base/krdc-${PV}:${SLOT}
	>=kde-base/krfb-${PV}:${SLOT}
	>=kde-base/ksirc-${PV}:${SLOT}
	>=kde-base/ktalkd-${PV}:${SLOT}
	wifi? ( >=kde-base/kwifimanager-${PV}:${SLOT} )
	>=kde-base/librss-${PV}:${SLOT}
	>=kde-base/kdnssd-${PV}:${SLOT}
	>=kde-base/kdenetwork-kfile-plugins-${PV}:${SLOT}
	>=kde-base/lisa-${PV}:${SLOT}"
