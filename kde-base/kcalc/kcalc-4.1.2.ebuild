# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kcalc/kcalc-4.1.2.ebuild,v 1.1 2008/10/02 06:53:34 jmbsvicetto Exp $

EAPI="2"

KMNAME=kdeutils
CPPUNIT_REQUIRED="optional"
inherit kde4-meta

DESCRIPTION="KDE calculator"
KEYWORDS="~amd64 ~x86"
IUSE="debug htmlhandbook"

DEPEND="dev-libs/gmp"
RDEPEND="${DEPEND}"

src_test() {
	pushd "${WORKDIR}"/${PN}_build/kcalc/knumber/tests > /dev/null
	emake knumbertest && \
		./knumbertest.shell || die "Tests failed."
	popd > /dev/null
}
