# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kcalc/kcalc-4.6.5.ebuild,v 1.1 2011/07/09 15:14:04 alexxy Exp $

EAPI=4

KDE_HANDBOOK="optional"
KMNAME="kdeutils"
CPPUNIT_REQUIRED="optional"
inherit kde4-meta

DESCRIPTION="KDE calculator"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
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
