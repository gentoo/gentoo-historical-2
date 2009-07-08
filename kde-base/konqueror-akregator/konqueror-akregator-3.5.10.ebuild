# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/konqueror-akregator/konqueror-akregator-3.5.10.ebuild,v 1.6 2009/07/08 14:29:34 alexxy Exp $
KMNAME=kdeaddons
KMNOMODULE=true
KMEXTRA="konq-plugins/akregator"
EAPI="1"
inherit kde-meta

DESCRIPTION="konqueror's akregator plugin"
KEYWORDS="~alpha amd64 hppa ~ia64 ~mips ppc ppc64 ~sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="|| ( >=kde-base/konqueror-${PV}:${SLOT} >=kde-base/kdebase-${PV}:${SLOT} )"
RDEPEND="${DEPEND}
>=kde-base/kdeaddons-docs-konq-plugins-${PV}:${SLOT}
|| ( >=kde-base/akregator-${PV}:${SLOT} >=kde-base/kdepim-${PV}:${SLOT} )"
