# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/knode/knode-4.3.3.ebuild,v 1.4 2009/11/30 06:54:42 josejx Exp $

EAPI="2"

KMNAME="kdepim"
inherit kde4-meta

DESCRIPTION="A newsreader for KDE"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ppc64 ~sparc ~x86"
IUSE="debug +handbook"

# test fails, last checked for 4.2.96
RESTRICT=test

DEPEND="
	$(add_kdebase_dep libkdepim)
	$(add_kdebase_dep libkpgp)
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
	libkpgp/
"

KMLOADLIBS="libkdepim"

src_unpack() {
	if use handbook; then
		KMEXTRA="
			doc/kioslave/news
		"
	fi

	kde4-meta_src_unpack
}
