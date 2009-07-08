# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdewebdev-meta/kdewebdev-meta-3.5.10.ebuild,v 1.6 2009/07/08 13:54:44 alexxy Exp $

EAPI="1"
inherit kde-functions
DESCRIPTION="kdewebdev - merge this to pull in all kdewebdev-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="3.5"
KEYWORDS="~alpha amd64 hppa ~ia64 ~mips ppc ppc64 ~sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="
>=kde-base/kfilereplace-${PV}:${SLOT}
>=kde-base/kimagemapeditor-${PV}:${SLOT}
>=kde-base/klinkstatus-${PV}:${SLOT}
>=kde-base/kommander-${PV}:${SLOT}
>=kde-base/kxsldbg-${PV}:${SLOT}
>=kde-base/quanta-${PV}:${SLOT}
"
