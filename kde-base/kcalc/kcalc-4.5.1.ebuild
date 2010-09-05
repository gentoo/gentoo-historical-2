# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kcalc/kcalc-4.5.1.ebuild,v 1.1 2010/09/05 23:30:51 tampakrap Exp $

EAPI="3"

KDE_HANDBOOK=1
KMNAME="kdeutils"
CPPUNIT_REQUIRED="optional"
inherit kde4-meta

DESCRIPTION="KDE calculator"
KEYWORDS=""
IUSE="debug"

DEPEND="
	dev-libs/gmp
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-4.3.2-solaris-knumber_priv.patch
)

src_test() {
	LANG=C kde4-meta_src_test
}
