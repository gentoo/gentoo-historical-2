# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kcalc/kcalc-4.11.5.ebuild,v 1.6 2014/02/23 09:08:46 ago Exp $

EAPI=5

KDE_HANDBOOK="optional"
CPPUNIT_REQUIRED="optional"
inherit kde4-base

DESCRIPTION="KDE calculator"
HOMEPAGE="http://www.kde.org/applications/utilities/kcalc
http://utils.kde.org/projects/kcalc"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	dev-libs/gmp
"
RDEPEND="${DEPEND}"

RESTRICT=test
# Testing result of: KNumber("nan") ^ KNumber("inf") should give nan and gives inf ...

src_test() {
	LANG=C kde4-base_src_test
}
