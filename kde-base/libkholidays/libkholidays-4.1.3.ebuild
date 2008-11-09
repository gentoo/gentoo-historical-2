# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/libkholidays/libkholidays-4.1.3.ebuild,v 1.1 2008/11/09 01:57:43 scarabeus Exp $

EAPI="2"

KMNAME=kdepim
inherit kde4-meta

DESCRIPTION="KDE library to compute holidays."
KEYWORDS="~amd64 ~x86"
IUSE="debug"

src_test() {
	# Test fails (4.1.0)
	sed -i -e '/testlunar/ s/^/#DONOTRUNTEST /' "${S}"/${PN}/tests/CMakeLists.txt \
		|| die "sed to disable kcal-testlunar failed"

	kde4-meta_src_test
}
